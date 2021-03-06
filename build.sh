ECHO="0"

TEST_MODE=$1
if [ "${TEST_MODE}" == "" ] || [ "${TEST_MODE}" == "a" ]; then TEST_MODE="all"; fi
if [ "${TEST_MODE}" == "d" ]; then TEST_MODE="darknet"; fi
if [ "${TEST_MODE}" == "i" ]; then TEST_MODE="inference_engine"; fi
if [ "${TEST_MODE}" == "q" ]; then TEST_MODE="quantization"; fi
if [ "${TEST_MODE}" == "u" ]; then TEST_MODE="use_samples"; fi

BUILD_DIR=build
if [ ${ECHO} == "1" ]; then echo "Build Synet in '${BUILD_DIR}':"; fi

if [ ! -d $BUILD_DIR ]; then mkdir $BUILD_DIR; fi

cd $BUILD_DIR

cmake ../prj/cmake -DMODE=$TEST_MODE -DTOOLCHAIN="g++" -DSYNET_INFO=$ECHO -DSIMD_AVX512=0 -DSIMD_AVX512VNNI=0 -DBLIS=0 -DPERF_STAT=3
if [ $? -ne 0 ] ; then 	exit; fi

make "-j$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)" 
if [ $? -ne 0 ] ; then 	exit; fi
