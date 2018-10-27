#pragma once

#include <vcpkg/base/files.h>
#include <vcpkg/base/optional.h>
#include <vcpkg/base/strings.h>

namespace vcpkg::System
{
    enum class Color
    {
        success = 10,
        error = 12,
        warning = 14,
    };

    void printfln();
    void printf(const CStringView message);
    void printfln(const CStringView message);
    void printf(const Color c, const CStringView message);
    void printfln(const Color c, const CStringView message);

    template<class Arg1, class... Args>
    void printf(const char* message_template, const Arg1& message_arg1, const Args&... message_args)
    {
        return System::printf(Strings::format(message_template, message_arg1, message_args...));
    }

    template<class Arg1, class... Args>
    void printf(const Color c, const char* message_template, const Arg1& message_arg1, const Args&... message_args)
    {
        return System::printf(c, Strings::format(message_template, message_arg1, message_args...));
    }

    template<class Arg1, class... Args>
    void printfln(const char* message_template, const Arg1& message_arg1, const Args&... message_args)
    {
        return System::printfln(Strings::format(message_template, message_arg1, message_args...));
    }

    template<class Arg1, class... Args>
    void printfln(const Color c, const char* message_template, const Arg1& message_arg1, const Args&... message_args)
    {
        return System::printfln(c, Strings::format(message_template, message_arg1, message_args...));
    }

    Optional<std::string> get_environment_variable(const CStringView varname) noexcept;

    Optional<std::string> get_registry_string(void* base_hkey, const CStringView subkey, const CStringView valuename);

    enum class CPUArchitecture
    {
        X86,
        X64,
        ARM,
        ARM64,
    };

    Optional<CPUArchitecture> to_cpu_architecture(const CStringView& arch);

    CPUArchitecture get_host_processor();

    std::vector<CPUArchitecture> get_supported_host_architectures();

    const Optional<fs::path>& get_program_files_32_bit();

    const Optional<fs::path>& get_program_files_platform_bitness();
}

namespace vcpkg::Debug
{
    void printfln(const CStringView message);
    void printfln(const System::Color c, const CStringView message);

    template<class Arg1, class... Args>
    void printfln(const char* message_template, const Arg1& message_arg1, const Args&... message_args)
    {
        return Debug::printfln(Strings::format(message_template, message_arg1, message_args...));
    }

    template<class Arg1, class... Args>
    void printfln(const System::Color c,
                  const char* message_template,
                  const Arg1& message_arg1,
                  const Args&... message_args)
    {
        return Debug::printfln(c, Strings::format(message_template, message_arg1, message_args...));
    }
}
