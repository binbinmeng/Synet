DATE_TIME=`date +"%Y_%m_%d__%H_%M"`

function TEST {
FRAMEWORK=$1
NAME=$2
NUMBER=$3
THREAD=$4
FORMAT=$5
BATCH=$6
DIR=./data/"$FRAMEWORK"/"$NAME"
PATHES="-fm=$DIR/other.dsc -fw=$DIR/other.dat -sm=$DIR/synet$FORMAT.xml -sw=$DIR/synet$FORMAT.bin -id=$DIR/image -od=$DIR/output -tp=$DIR/param.xml"
PREFIX="${FRAMEWORK:0:1}"
OUT=./test/check/"$DATE_TIME$PREFIX"
LOG="$OUT"/c"$PREFIX"_"$NAME"_f"$FORMAT"_b"$BATCH".txt
BIN_DIR=./build #_"$FRAMEWORK"
BIN="$BIN_DIR"/test_"$FRAMEWORK"

if [ "${NAME:0:5}" = "test_" ] && [ "${NAME:8:9}" = "i" ]; then
  THRESHOLD=0.016
  echo "Use increased accuracy threshold : $THRESHOLD for INT8."
else
  THRESHOLD=0.0011
fi

echo $LOG

if [ -f $DIR/image/descript.ion ];then rm $DIR/image/descript.ion; fi

export LD_LIBRARY_PATH="$BIN_DIR":$LD_LIBRARY_PATH

"$BIN" -m=convert $PATHES -tf=$FORMAT
if [ $? -ne 0 ]; then echo "Test $DIR is failed!"; exit; fi

"$BIN" -m=compare -e=3 $PATHES -if=*.* -rn=$NUMBER -wt=1 -tt=$THREAD -tf=$FORMAT -bs=$BATCH -t=$THRESHOLD -cs=1 -ln=$LOG
if [ $? -ne 0 ]; then echo "Test $DIR is failed!"; exit; fi
}

function TEST_I {
FRAMEWORK=inference_engine
NAME=$1
TEST_BATCH=$2
NUMBER=1
THREAD=0
TEST $FRAMEWORK $NAME $NUMBER $THREAD 0 1
TEST $FRAMEWORK $NAME $NUMBER $THREAD 1 1
if [ $TEST_BATCH -eq 1 ];then TEST $FRAMEWORK $NAME $NUMBER $THREAD 1 2; fi
}

function TEST_ALL_I {
TEST_I test_000 1
TEST_I test_001 1
TEST_I test_002 0
TEST_I test_003f 0
#TEST_I test_003i 0
TEST_I test_004 0
TEST_I test_005 1
TEST_I test_006 1
TEST_I test_007 1
TEST_I test_008 1
TEST_I test_009f 0
TEST_I test_010f 0
TEST_I test_011f 0
}

TEST_ALL_I

exit
