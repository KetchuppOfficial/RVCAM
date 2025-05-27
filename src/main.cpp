#include <exception>
#include <memory>

#include <fmt/core.h>

#include <CLI/CLI.hpp>

#include <verilated.h>

#include "rvcam.h" // generated during verilation

int main(int argc, char **argv) try
{
    CLI::App app{"RV64I SystemVerilog model"};

    unsigned char start;
    app.add_option("--start", start, "Number from which to start counting")
        ->default_val(0)
        ->check(CLI::Range(0, 254));

    CLI11_PARSE(app, argc, argv);

    const auto context = std::make_unique<VerilatedContext>();
    context->commandArgs(argc, argv);

    using deleter_type = decltype([](rvcam *model){
        model->final();
        std::default_delete<rvcam>{}(model);
    });
    const auto top = std::unique_ptr<rvcam, deleter_type>(new rvcam{context.get()});

    top->reset = true;

    return 0;
}
catch (const std::exception &e) {
    fmt::println(stderr, "Caught an instance of {}.\nwhat(): {}", typeid(e).name(), e.what());
    return -1;
}
catch (...)
{
    fmt::println(stderr, "Caught an unknown exception.");
    return -1;
}
