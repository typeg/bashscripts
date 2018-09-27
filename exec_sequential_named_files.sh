#!/bin/bash

FILENAME=file_prefix.

for i in $(seq -f "%06g" 0 50)
do
  echo $(date)" zipping $FILENAME$i" >> exec_history.log
  gzip $FILENAME$i
  echo $(date)" zip complete $FILENAME$i" >> exec_history.log
done