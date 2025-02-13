##
## Author:   liyuqihxc
## License:  See LICENSE file included in the project
##
##
## stm32f103 target specific CMake file
##

if(NOT DEFINED MCU_LINKER_SCRIPT)
    message(FATAL_ERROR "No linker script defined")
endif(NOT DEFINED MCU_LINKER_SCRIPT)
message("Linker script: ${MCU_LINKER_SCRIPT}")

set(MCU_FAMILY STM32F1xx)

# Generated by STM32CubeMX.
set(HAL_DIR ${CMAKE_SOURCE_DIR}/Drivers/STM32F1xx_HAL_Driver)
set(DEVICE_DIR ${CMAKE_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F1xx)

include_directories(${DEVICE_DIR}/Include)
include_directories(${HAL_DIR}/Inc)

include(${CMAKE_SOURCE_DIR}/cmake/stm32cubemx_config.cmake)

# Compile and link
set(FPU "")
set(FLOAT-ABI "")
set(MCU_FLAGS "-mcpu=cortex-m3 ${FPU} ${FLOAT-ABI}")
set(COMMON_FLAGS "${MCU_FLAGS} -DUSE_HAL_DRIVER -D${MCU_LINE}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COMMON_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${MCU_FLAGS} -T \"${MCU_LINKER_SCRIPT}\"")

file(GLOB HAL_DIR_SOURCE "${HAL_DIR}/Src/stm32f1xx_hal_*.c")
list(REMOVE_ITEM HAL_DIR_SOURCE
"${HAL_DIR}/Src/stm32f1xx_hal_msp_template.c"
"${HAL_DIR}/Src/stm32f1xx_hal_timebase_rtc_alarm_template.c"
"${HAL_DIR}/Src/stm32f1xx_hal_timebase_tim_template.c")

add_library(STM32F1_DEVICE_HAL STATIC
  ${CORE_DIR}/Src/stm32f1xx_it.c
  ${CORE_DIR}/Src/stm32f1xx_hal_msp.c
  ${CORE_DIR}/Src/system_stm32f1xx.c
  ${STARTUP_ASSEMBLY}
  ${HAL_DIR_SOURCE}
)
