#!/bin/bash

# Copyright 2019 Decipher Technology Studios
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

VERSION="${1:-$(cat VERSION)}"

MAJOR="$(echo ${VERSION} | awk -F '[\.\-]' '{print $1}')"
MINOR="$(echo ${VERSION} | awk -F '[\.\-]' '{print $2}')"
PATCH="$(echo ${VERSION} | awk -F '[\.\-]' '{print $3}')"
BUILD="$(echo ${VERSION} | awk -F '[\.\-]' '{print $4}')"

docker push "deciphernow/nexus:${MAJOR}"
docker push "deciphernow/nexus:${MAJOR}.${MINOR}"
docker push "deciphernow/nexus:${MAJOR}.${MINOR}.${PATCH}"
docker push "deciphernow/nexus:${MAJOR}.${MINOR}.${PATCH}-${BUILD}"
