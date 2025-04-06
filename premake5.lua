-- glfw

require("premake", ">=5.0.0-beta6")

project "glfw"
  kind "StaticLib"
  language "C"
  cdialect "gnu99"
  staticruntime "On"
  systemversion "latest"

  targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
  objdir ("%{wks.location}/build/" .. outputdir .. "%{prj.name}")

  removedefines {
    "GLFW_INCLUDE_NONE" -- ensure GLFW_INCLUDE_NONE is not defined during glfw compilation
  }

  files {
    "premake5.lua",

    "include/GLFW/glfw3.h",
    "include/GLFW/glfw3native.h",

    "src/internal.h",
    "src/platform.h",
    "src/mappings.h",
    "src/context.c",
    "src/init.c",
    "src/input.c",
    "src/monitor.c",
    "src/platform.c",
    "src/vulkan.c",
    "src/window.c",
    "src/egl_context.c",
    "src/osmesa_context.c",
    "src/null_platform.h",
    "src/null_joystick.h",
    "src/null_init.c",
    "src/null_monitor.c",
    "src/null_window.c",
    "src/null_joystick.c",
  }

  filter "system:windows"
    -- buildoptions{
    --     "/MT"
    -- }

    files {
      -- Time
      "src/win32_time.h",
      "src/win32_thread.h",
      "src/win32_time.c",
      "src/win32_thread.c",
      "src/win32_module.c",

      -- Build WIN32
      "src/win32_init.c",
      "src/win32_joystick.c",
      "src/win32_monitor.c",
      "src/win32_window.c",
      "src/wgl_context.c"
    }

    defines {
      "_GLFW_WIN32",
      "_CRT_SECURE_NO_WARNINGS"
    }

    links {
      "Dwmapi.lib"
    }

  filter "system:linux"
    pic "On"

    files {
      -- Time
      "posix_time.h",
      "posix_thread.h",
      "posix_time.c",
      "posix_thread.c",
      "posix_module.c",

      -- build x11
      "src/x11_platform.h",
      "src/xkb_unicode.h",
      "src/x11_init.c",
      "src/x11_monitor.c",
      "src/x11_window.c",
      "src/xkb_unicode.c",
      "src/glx_context.c",

      -- Build Wayland
      -- not supported yet

      -- x11 || Wayland
      "src/linux_joystick.h",
      "src/linux_joystick.c",
      "src/posix_poll.h",
      "src/posix_poll.c"
    }

    defines {
      "_GLFW_X11"
    }

  filter "system:macosx"
    pic "On"

    files {
      -- Time
      "src/cocoa_time.h",
      "src/cocoa_time.c",
      "src/posix_thread.h",
      "src/posix_module.c",
      "src/posix_thread.c",

      -- Build Cocoa
      "src/cocoa_platform.h",
      "src/cocoa_joystick.h",
      "src/cocoa_init.m",
      "src/cocoa_joystick.m",
      "src/cocoa_monitor.m",
      "src/cocoa_window.m",
      "src/nsgl_context.m"
    }

    defines {
      "_GLFW_COCOA"
    }

    links { "Cocoa", "IOKit", "CoreFoundation" }

  filter "configurations:Debug"
    runtime "Debug"
    symbols "On"

  filter "configurations:Release"
    runtime "Release"
    optimize "On"

  usage "PUBLIC"
    includedirs { "./include" }

  usage "INTERFACE"
    defines { "GLFW_INCLUDE_NONE" } -- Require any dependent project to implement it's own opengl loader
    links { "glfw" }
