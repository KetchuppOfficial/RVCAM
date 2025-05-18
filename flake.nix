{
    description = "RISC-V verilog model";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    };

    outputs = {
        nixpkgs,
        ...
    }: let
        system = "x86_64-linux";
    in {
        devShells."${system}".default = let
            pkgs = import nixpkgs {
                inherit system;
            };
        in pkgs.mkShell {
            buildInputs = with pkgs; [
                verilator
                fmt
                elfio
                cli11
            ];
            nativeBuildInputs = with pkgs; [
                cmake
                clang-tools
                jq
            ];
            shellHook = let
                vscodeDir = ".vscode";
                vscodeConfig = {
                    "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
                };
            in ''
            mkdir -p ${vscodeDir}
            jq --indent 4 -n '${builtins.toJSON vscodeConfig}' > ${vscodeDir}/settings.json
            '';
        };
    };
}
