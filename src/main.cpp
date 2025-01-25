//===- toyc.cpp - The Toy Compiler ----------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the entry point for the Toy compiler.
//
//===----------------------------------------------------------------------===//

#include "AST.h"
#include "Lexer.h"
#include "MLIRGen.h"
#include "Parser.h"
#include "Passes.h"
#include "toy/Dialect.h"

#include "mlir/Dialect/Affine/Passes.h"
#include "mlir/Dialect/Func/Extensions/AllExtensions.h"
#include "mlir/IR/AsmState.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Verifier.h"
#include "mlir/InitAllDialects.h"
#include "mlir/Parser/Parser.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"

#include "llvm/ADT/StringRef.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>
#include <string>
#include <system_error>

using namespace toy;
namespace cl = llvm::cl;

std::string inputFilename = "/home/mowind/dev/mlir/tutorial/test/test.toy";

int dumpMLIR() {
    mlir::DialectRegistry registry;
    mlir::func::registerAllExtensions(registry);

    mlir::MLIRContext context(registry);
    context.getOrLoadDialect<mlir::toy::ToyDialect>();

    llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> fileOrErr =
        llvm::MemoryBuffer::getFileOrSTDIN(inputFilename);
    if (std::error_code ec = fileOrErr.getError()) {
        llvm::errs() << "Could not open input file: " << ec.message() << "\n";
        return -1;
    }
    auto        buffer = fileOrErr.get()->getBuffer();
    LexerBuffer lexer(buffer.begin(), buffer.end(), std::string(inputFilename));
    Parser      parser(lexer);

    std::unique_ptr<toy::ModuleAST> moduleAST = parser.parseModule();

    auto module = mlirGen(context, *moduleAST);

    mlir::PassManager pm(module.get()->getName());

    do {  // Inliner Passer
        pm.addPass(mlir::createInlinerPass());

        mlir::OpPassManager& optPM = pm.nest<mlir::toy::FuncOp>();
        optPM.addPass(mlir::toy::createShapeInferencePass());  // ShapeInferencePass
        optPM.addPass(mlir::createCanonicalizerPass());
        // Common Subexpression Elimination.
        optPM.addPass(mlir::createCSEPass());
    } while (0);

    do {
        // Partially lower the toy dialect.
        pm.addPass(mlir::toy::createLowerToAffinePass());

        // Add a few cleanups post lowering.
        mlir::OpPassManager& optPM = pm.nest<mlir::func::FuncOp>();
        optPM.addPass(mlir::createCanonicalizerPass());
        optPM.addPass(mlir::createCSEPass());
    } while (0);

    if (mlir::failed(pm.run(*module)))
        return 4;

    module->dump();
    return 0;
}

int main(int argc, char** argv) {
    // Register any command line options.
    mlir::registerAsmPrinterCLOptions();
    mlir::registerMLIRContextCLOptions();
    mlir::registerPassManagerCLOptions();

    cl::ParseCommandLineOptions(argc, argv, "toy compiler\n");

    return dumpMLIR();

    return 0;
}
