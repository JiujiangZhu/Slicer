
slicer_include_once()

# Set dependency list
set(SlicerExecutionModel_DEPENDENCIES ${ITK_EXTERNAL_NAME})

# Include dependent projects if any
SlicerMacroCheckExternalProjectDependency(SlicerExecutionModel)
set(proj SlicerExecutionModel)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED SlicerExecutionModel_DIR AND NOT EXISTS ${SlicerExecutionModel_DIR})
  message(FATAL_ERROR "SlicerExecutionModel_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED SlicerExecutionModel_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  #message(STATUS "${__indent}Adding project ${proj}")

  set(EXTERNAL_PROJECT_OPTIONAL_ARGS)

  # Set CMake OSX variable to pass down the external project
  if(APPLE)
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()

  if(NOT CMAKE_CONFIGURATION_TYPES)
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_ARGS
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE})
  endif()

  if(APPLE)
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_ARGS
      -DSlicerExecutionModel_DEFAULT_CLI_EXECUTABLE_LINK_FLAGS:STRING=-Wl,-rpath,@loader_path/../../../
      )
  endif()

  if(NOT DEFINED git_protocol)
    set(git_protocol "git")
  endif()

  ExternalProject_Add(${proj}
    GIT_REPOSITORY "${git_protocol}://github.com/Slicer/SlicerExecutionModel.git"
    GIT_TAG "9202673b809fb7df0890a2b01c288dae0b02c598"
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${proj}-build
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags} # Unused
      -DBUILD_TESTING:BOOL=OFF
      -DITK_DIR:PATH=${ITK_DIR}
      -DSlicerExecutionModel_LIBRARY_PROPERTIES:STRING=${Slicer_LIBRARY_PROPERTIES}
      -DSlicerExecutionModel_INSTALL_BIN_DIR:PATH=${Slicer_INSTALL_LIB_DIR}
      -DSlicerExecutionModel_INSTALL_LIB_DIR:PATH=${Slicer_INSTALL_LIB_DIR}
      #-DSlicerExecutionModel_INSTALL_SHARE_DIR:PATH=${Slicer_INSTALL_ROOT}share/${SlicerExecutionModel}
      -DSlicerExecutionModel_INSTALL_NO_DEVELOPMENT:BOOL=${Slicer_INSTALL_NO_DEVELOPMENT}
      -DSlicerExecutionModel_DEFAULT_CLI_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Slicer_BINARY_INNER_SUBDIR}/${Slicer_CLIMODULES_BIN_DIR}
      -DSlicerExecutionModel_DEFAULT_CLI_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Slicer_BINARY_INNER_SUBDIR}/${Slicer_CLIMODULES_LIB_DIR}
      -DSlicerExecutionModel_DEFAULT_CLI_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_BINARY_DIR}/${Slicer_BINARY_INNER_SUBDIR}/${Slicer_CLIMODULES_LIB_DIR}
      -DSlicerExecutionModel_DEFAULT_CLI_INSTALL_RUNTIME_DESTINATION:STRING=${Slicer_INSTALL_CLIMODULES_BIN_DIR}
      -DSlicerExecutionModel_DEFAULT_CLI_INSTALL_LIBRARY_DESTINATION:STRING=${Slicer_INSTALL_CLIMODULES_LIB_DIR}
      -DSlicerExecutionModel_DEFAULT_CLI_INSTALL_ARCHIVE_DESTINATION:STRING=${Slicer_INSTALL_CLIMODULES_LIB_DIR}
      ${EXTERNAL_PROJECT_OPTIONAL_ARGS}
    INSTALL_COMMAND ""
    DEPENDS
      ${SlicerExecutionModel_DEPENDENCIES}
    )
  set(SlicerExecutionModel_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
else()
  # The project is provided using SlicerExecutionModel_DIR, nevertheless since other project may depend on SlicerExecutionModel,
  # let's add an 'empty' one
  SlicerMacroEmptyExternalProject(${proj} "${SlicerExecutionModel_DEPENDENCIES}")
endif()
