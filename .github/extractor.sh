#!/bin/bash

# Check if a file is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <docker-compose-file>"
    exit 1
fi

# Read the provided Docker Compose file
compose_file="$1"

# Use awk to extract image names from lines starting with "image:"
images=$(awk '/^[[:blank:]]*image:/ && !/^ *#/ {gsub("\"", "", $2); print $2}' "$compose_file")


# Print the extracted image names
cat << EOF > Dockerfile
# This is a fake Dockerfile, that is generated automatically
# to list the images contained in a real docker-compose file.
# This hack enables dependabot alerts for docker-compose files,
# which right now are not supported
#
# Last update: $(date)
# images extracted from $compose_file

EOF

for image in $images; do
    echo "found: $image"
    echo "FROM $image" >> Dockerfile
    echo "RUN echo $image" >> Dockerfile
    echo " " >> Dockerfile
done

