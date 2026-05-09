fn main() {
    let src_dir = std::path::Path::new("grammars/bsl/src");
    let sdbl_src_dir = std::path::Path::new("grammars/sdbl/src");

    let mut c_config = cc::Build::new();
    c_config.std("c11").include(src_dir).include(sdbl_src_dir);

    #[cfg(target_env = "msvc")]
    c_config.flag("-utf-8");

    let parser_path = src_dir.join("parser.c");
    c_config.file(&parser_path);
    println!("cargo:rerun-if-changed={}", parser_path.to_str().unwrap());

    let sdbl_parser_path = sdbl_src_dir.join("parser.c");
    c_config.file(&sdbl_parser_path);
    println!(
        "cargo:rerun-if-changed={}",
        sdbl_parser_path.to_str().unwrap()
    );

    let scanner_path = src_dir.join("scanner.c");
    if scanner_path.exists() {
        c_config.file(&scanner_path);
        println!("cargo:rerun-if-changed={}", scanner_path.to_str().unwrap());
    }

    c_config.compile("tree-sitter-bsl");
}
