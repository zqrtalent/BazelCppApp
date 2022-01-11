load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# Rule repository
http_archive(
    name = "rules_foreign_cc",
    sha256 = "1df78c7d7eed2dc21b8b325a2853c31933a81e7b780f9a59a5d078be9008b13a",
    strip_prefix = "rules_foreign_cc-0.7.0",
    url = "https://github.com/bazelbuild/rules_foreign_cc/archive/0.7.0.tar.gz",
)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")
# This sets up some common toolchains for building targets. For more details, please see
# https://bazelbuild.github.io/rules_foreign_cc/0.7.0/flatten.html#rules_foreign_cc_dependencies
rules_foreign_cc_dependencies()

http_archive(
    name = "gtest",
    url = "https://github.com/google/googletest/archive/release-1.7.0.zip",
    sha256 = "b58cb7547a28b2c718d1e38aee18a3659c9e3ff52440297e965f5edffe34b6d0",
    build_file = "@//test:gtest.BUILD",
    strip_prefix = "googletest-release-1.7.0",
)

# # Group the sources of the library so that CMake rule have access to it
# all_content = """filegroup(name = "all", srcs = glob(["**"]), visibility = ["//visibility:public"])"""
# http_archive(
#     name = "mysqlconnectorcpp",
#     url = "https://github.com/mysql/mysql-connector-cpp/archive/8.0.20.zip",
#     sha256 = "d7ed33cd14e13d636ae0085863961cfc255183c07d69dcfe34911303bec9ad8d",
#     #build_file = "@//src/third_party:mysqlconnectorcpp.BUILD",
#     build_file_content = all_content,
#     strip_prefix = "mysql-connector-cpp-8.0.20",
# )

#https://github.com/nelhage/rules_boost
git_repository(
    name = "com_github_nelhage_rules_boost",
    commit = "1e3a69bf2d5cd10c34b74f066054cd335d033d71",
    remote = "https://github.com/nelhage/rules_boost",
    shallow_since = "1591047380 -0700",
)

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")
boost_deps()