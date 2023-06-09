#! /bin/bash

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "Polling endpoint for status"
      echo " "
      echo "./main.sh [options]"
      echo " "
      echo "options:"
      echo "-h, --help           Show brief help"
      echo "--url=URL            url to poll"
      echo "--APP_NAME=APP_NAME     repository name"
      echo "--API_CD_TOKEN=API_CD_TOKEN         token given by cd"
      echo "--JOB_ID=JOB_ID          job id given by cd api"
      echo "--interval=INTERVAL  Interval between each call, in seconds"
      echo "--timeout=TIMEOUT    Timeout before stop polling, in seconds"
      exit 0
      ;;
    --url*)
      url=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --APP_NAME*)
      APP_NAME=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --API_CD_TOKEN*)
      API_CD_TOKEN=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --JOB_ID*)
      JOB_ID=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --interval*)
      interval=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

function poll_status {
  while true;
  do
    curl -X POST -H "Content-Type: application/json" -d "{\"key\":\"$API_CD_TOKEN\",\"name\":\"$APP_NAME\",\"job_id\":\"$JOB_ID\"}" $url -s > temp.json;
    export iatus=$(cat temp.json | jq -cr '.status');
    cat temp.json;
    echo "$(date +%H:%M:%S): status is $iatus";
    if [[ "$iatus" == "finished" || "$iatus" == "error" ]]; then
        rm temp.json
        if [[ "$iatus" == "error" ]]; then
          echo "Deployment error!"
          exit 1;
        else
          echo "Deployment finished!";
          exit 0;
        fi
        break;
    fi;
    rm temp.json
    sleep $interval;
  done
  rm temp.json
}

printf "\nPolling '${url%\?*}' every $interval seconds, until status is 'finished'\n"
poll_status
