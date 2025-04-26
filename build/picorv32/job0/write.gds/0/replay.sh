#!/usr/bin/env bash
if [ "${BASH_SOURCE[0]}" != "$0" ]; then
    echo "${BASH_SOURCE[0]} must be executed."
    return
fi

# Parse replay arguments
CD_WORK="/nfs/sc_compute/builds/03ceb3a4f0e94730a95a08d439e9c2e9/picorv32/job0/write.gds/0"
PRINT=""
CMDPREFIX=""
SKIPEXPORT=0
while [[ $# -gt 0 ]]; do
    case $1 in
        --which)
            PRINT="which"
            shift
            ;;
        --version)
            PRINT="version"
            shift
            ;;
        --directory)
            PRINT="directory"
            shift
            ;;
        --command)
            PRINT="command"
            shift
            ;;
        --skipcd)
            CD_WORK="."
            shift
            ;;
        --skipexports)
            SKIPEXPORT=1
            shift
            ;;
        --cmdprefix)
            CMDPREFIX="$2"
            shift
            shift
            ;;
        -h|--help)
            echo "Usage: $0"
            echo "  Options:"
            echo "    --which           print which executable would be used"
            echo "    --version         print the version of the executable, if supported"
            echo "    --directory       print the execution directory"
            echo "    --command         print the execution command"
            echo "    --skipcd          do not change directory into replay directory"
            echo "    --skipexports     do not export environmental variables"
            echo "    --cmdprefix <cmd> prefix to add to the replay command, such as gdb"
            echo "    -h,--help         print this help"
            exit 0
            ;;
        *)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

if [ $SKIPEXPORT == 0 ]; then
    # Environmental variables
    export QT_QPA_PLATFORM="offscreen"
    export PATH="/venv/bin:/sc_tools/bin:/sc_tools/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    export LD_LIBRARY_PATH="/sc_tools/lib:/sc_tools/lib64"
fi

# Switch to the working directory
cd "$CD_WORK"

case $PRINT in
    "which")
        which klayout
        exit 0
        ;;
    "version")
        klayout -zz -v
        exit 0
        ;;
    "directory")
        echo "Working directory: $PWD"
        exit 0
        ;;
    "command")
        echo "klayout -z -nc -rx -r /venv/lib/python3.10/site-packages/siliconcompiler/tools/klayout/klayout_export.py -rd SC_KLAYOUT_ROOT=/venv/lib/python3.10/site-packages/siliconcompiler/tools/klayout -rd SC_TOOLS_ROOT=/venv/lib/python3.10/site-packages/siliconcompiler/tools"
        exit 0
        ;;
esac

# Command execution
$CMDPREFIX \
klayout \
  -z \
  -nc \
  -rx \
  -r \
  /venv/lib/python3.10/site-packages/siliconcompiler/tools/klayout/klayout_export.py \
  -rd SC_KLAYOUT_ROOT=/venv/lib/python3.10/site-packages/siliconcompiler/tools/klayout \
  -rd SC_TOOLS_ROOT=/venv/lib/python3.10/site-packages/siliconcompiler/tools
