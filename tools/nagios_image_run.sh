#!/bin/bash
# Copyright 2017 The Openstack-Helm Authors.
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

set -x

IMAGE=$1

docker run \
    -p 1800:80 \
    -e 'PROMETHEUS_SERVICE=test' \
    --name nagios_test ${IMAGE} \
    &

sleep 5

RESULT="$(curl -i 'http://127.0.0.1:1800' | tr '\r' '\n' | head -1)"

docker stop nagios_test
docker rm nagios_test

GOOD="HTTP/1.1 302 Found"
if [[ ${RESULT} == ${GOOD} ]]; then
    exit 0
else
    exit 1
fi