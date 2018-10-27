#pragma once

#include <vcpkg/base/cstringview.h>
#include <vcpkg/base/files.h>

#include <string>
#include <unordered_map>
#include <vector>

namespace vcpkg::System
{
    struct CMakeVariable
    {
        CMakeVariable(const CStringView varname, const char* varvalue);
        CMakeVariable(const CStringView varname, const std::string& varvalue);
        CMakeVariable(const CStringView varname, const fs::path& path);

        std::string s;
    };

    std::string make_cmake_cmd(const fs::path& cmake_exe,
                               const fs::path& cmake_script,
                               const std::vector<CMakeVariable>& pass_variables);

    fs::path get_exe_path_of_current_process();

    struct ExitCodeAndOutput
    {
        int exit_code;
        std::string output;
    };

    int cmd_execute_clean(const CStringView cmd_line,
                          const std::unordered_map<std::string, std::string>& extra_env = {}) noexcept;

    int cmd_execute(const CStringView cmd_line) noexcept;

#if defined(_WIN32)
    void cmd_execute_no_wait(const CStringView cmd_line) noexcept;
#endif

    ExitCodeAndOutput cmd_execute_and_capture_output(const CStringView cmd_line) noexcept;
}
