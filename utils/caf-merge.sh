#!/bin/bash
#
# Copyright (C) 2021 OmniROM Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
echo -e "Enter the CAF ref to merge";
read ref;

cd ../../../

while read path;
    do

    project=`echo android_${path} | sed -e 's/\//\_/g'`;
    caf_project=${path};
    if [ "${path}" == "build" ] ; then
        path="build/make";
    fi

    echo "";
    echo "=====================================================================";
    echo " PROJECT: ${project} -> [ ${path}/ ]";
    echo "";

    rm -fr $path;
    echo " -> repo sync ${path}";
    ret=$(repo sync -d -f --force-sync ${path} 2>&1);
    cd $path;

    # make sure that environment is clean
    ret=$(git merge --abort 2>&1);

    echo " -> Merging remote: https://source.codeaurora.org/quic/la/platform/$caf_project ${ref}";
    ret=$(git pull https://source.codeaurora.org/quic/la/platform/$caf_project ${ref} 2>&1);

    if echo $ret | grep "CONFLICT (content)" > /dev/null ; then
        echo -e " -> \e[33mWARNING!: \e[31mMERGE CONFLICT\e[0m";
    else
        echo -e " -> \e[32mDONE!\e[0m";
    fi

    cd - > /dev/null;

done < vendor/omni/utils/caf-repos-list;