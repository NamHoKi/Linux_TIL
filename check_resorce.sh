#!/bin/bash

echo -e `date` >> /app/rs.txt
echo -e `mpstat | grep all` >> /app/rs.txt
echo -e `free -m -h G | grep Mem` >> /app/rs.txt
