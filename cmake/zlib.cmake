# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

include_guard()

include(cmake/utils.cmake)

FetchContent_DeclareGitHubWithMirror(zlib
  madler/zlib v1.2.12
  MD5=50f045c0f544726cf70d1d865bb4d6a4
)

FetchContent_GetProperties(zlib)
if(NOT zlib_POPULATED)
  FetchContent_Populate(zlib)

  if(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
    set(APPLE_FLAG "CFLAGS=-isysroot ${CMAKE_OSX_SYSROOT}")
  endif()

  execute_process(COMMAND ${zlib_SOURCE_DIR}/configure ${APPLE_FLAG} --static
    WORKING_DIRECTORY ${zlib_BINARY_DIR}
  )

  add_custom_target(make_zlib COMMAND make CC=${CMAKE_C_COMPILER} ${APPLE_FLAG}
    WORKING_DIRECTORY ${zlib_BINARY_DIR}
    BYPRODUCTS ${zlib_BINARY_DIR}/libz.a
  )
endif()

add_library(zlib INTERFACE)
target_include_directories(zlib INTERFACE $<BUILD_INTERFACE:${zlib_BINARY_DIR}>)
target_link_libraries(zlib INTERFACE $<BUILD_INTERFACE:${zlib_BINARY_DIR}/libz.a>)
add_dependencies(zlib make_zlib)
