cc_binary(
    name = "main",
    srcs = [
        "main.cpp"
    ],
    deps = [],
    includes = [],
    linkopts = [
        "-lresolv", #MacOS link resolv lib.
    ],
    linkstatic = 1, # default value
)

genrule(
    name = "main_dsym",
    srcs = [":main"],
    outs = ["main.dSYM"],
    output_to_bindir = True,
    cmd = "dsymutil $(location :main) -o $@"
)