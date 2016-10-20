#!groovy
//
// Jenkins Pipeline script to produce builds
//
// Copyright (c) 2016, Intel Corporation.
//
// This program is free software; you can redistribute it and/or modify it
// under the terms and conditions of the GNU General Public License,
// version 2, as published by the Free Software Foundation.
//
// This program is distributed in the hope it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//


def is_pr = env.JOB_NAME.endsWith("_pull-requests")
if (is_pr) {
    setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Run #${env.BUILD_NUMBER} started"
}

def base_distro = "ostro-os"

def target_machine = "intel-corei7-64"
def test_devices = [ "bxtc", "minnowboardmax" ]

// Base container OS to use
// opensuse-42.1, opensuse-tumbleweed, fedora-23, ...
def build_os = "opensuse-42.1"


// JOB_NAME expected to be in form <layer>_<branch>
def current_project = "${env.JOB_NAME}".tokenize("_")[0]
def image_name = "${current_project}_build:${env.BUILD_TAG}"

def testing_script = ""
def testinfo_data = ""

try {
    node('docker') {
        ws ("workspace/builder-slot-${env.EXECUTOR_NUMBER}") {
            stage 'Cleanup workspace'
            deleteDir()

            stage 'Checkout own content'
            if (binding.variables.get("GITHUB_PR_NUMBER")) {
                // we are building pull request
                checkout([$class: 'GitSCM',
                    branches: [
                        [name: "origin-pull/$GITHUB_PR_NUMBER/$GITHUB_PR_COND_REF"]
                    ],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [
                        [$class: 'SubmoduleOption',
                            disableSubmodules: false,
                            recursiveSubmodules: true,
                            reference: "${env.PUBLISH_DIR}/bb-cache/.git-mirror",
                            trackingSubmodules: false],
                        [$class: 'CleanBeforeCheckout']
                    ],
                    submoduleCfg: [],
                        userRemoteConfigs: [
                        [
                            credentialsId: "${GITHUB_AUTH}",
                            name: 'origin-pull',
                            refspec: "+refs/pull/$GITHUB_PR_NUMBER/*:refs/remotes/origin-pull/$GITHUB_PR_NUMBER/*",
                            url: "${GITHUB_PROJECT}"
                        ]
                    ]
                ])
            } else {
                checkout poll: false, scm: scm
            }

            stage 'Cleanup old build directory'
            dir('build') {
                deleteDir()
            }

            stage 'Build docker image'
            if (is_pr) {
                setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Building Docker image"
            }

            def build_args = [ build_proxy_args(), build_user_args()].join(" ")

            sh "docker build -t ${image_name} ${build_args} docker/${build_os}"
            dockerFingerprintFrom dockerfile: "docker/${build_os}/Dockerfile", image: "${image_name}"

            def docker_image = docker.image(image_name)

            run_args = ["-v ${env.PUBLISH_DIR}:${env.PUBLISH_DIR}:rw",
                        run_proxy_args()].join(" ")

            // Prepare environment for calling other scripts.
            def script_env = """
                export WORKSPACE=\$PWD
                export HOME=\$JENKINS_HOME
                export BASE_DISTRO=${base_distro}
                export CURRENT_PROJECT=${current_project}
                export BUILD_CACHE_DIR=${env.PUBLISH_DIR}/bb-cache
                export PUBLISH_DIR=${env.PUBLISH_DIR}
                export GIT_PROXY_COMMAND=oe-git-proxy
                export CI_BUILD_ID=${env.BUILD_TIMESTAMP}-build-${env.BUILD_NUMBER}
                export TARGET_MACHINE=${target_machine}
                export GIT_COMMITTER_NAME="Ostro Project CI"
                export GIT_COMMITTER_EMAIL='ci@ostroproject.org'
            """
            timestamps {
            sshagent(['github-auth-ssh']) {
                docker_image.inside(run_args) {
                    stage 'Bitbake Build'
                    if (is_pr) {
                        setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Bitbake Build"
                    }
                    params = ["${script_env}",
                    "docker/build-project.sh"].join("\n")
                    sh "${params}"

                    stage "Build publishing"
                    if (is_pr) {
                        setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Build publishing"
                    }
                    params =  ["${script_env}",
                    "docker/publish-project.sh"].join("\n")
                    sh "${params}"
                }
            } // sshagent
            } // timestamps
            // all good, cleanup image (disabled for now, as also removes caches)
            // sh "docker rmi ${image_name}"
            tester_script = readFile "docker/tester-exec.sh"
            testinfo_data = readFile "${target_machine}.testinfo.csv"
        }

    }

    def test_runs = [:]
    for(int i=0; i < test_devices.size(); i++) {
        def test_device = test_devices[i]
        test_runs["test_${test_device}"] = {
            node('ostro-tester') {
                // clean workspace
                echo 'Cleanup testing workspace'
                deleteDir()
                echo "Testing"
                writeFile file: 'tester-exec.sh', text: tester_script
                writeFile file: 'testinfo.csv', text: testinfo_data

                def ci_build_id = "${env.BUILD_TIMESTAMP}-build-${env.BUILD_NUMBER}"
                withEnv(["CI_BUILD_ID=${ci_build_id}",
                         "CI_BUILD_URL=${env.COORD_BASE_URL}/builds/${env.JOB_NAME}/${ci_build_id}",
                         "MACHINE=${target_machine}",
                         "TEST_DEVICE=${test_device}" ]){
                    sh 'env && chmod a+x tester-exec.sh && ./tester-exec.sh'
                }

                sh "sed -e 's/name=\"oeqa/name=\"${test_device}.oeqa/g' -i TEST-*.xml"
                sh "rename TEST- TEST-${test_device}- TEST-*.xml"
                sh "rename aft- aft-${test_device} aft-*"
                sh "rename .log .${test_device}.log *.log"

                archive '**/*.log, **/*.xml, **/aft-results-*.tar.bz2'

                step([$class: 'XUnitPublisher',
                    testTimeMargin: '3000',
                    thresholdMode: 1,
                    thresholds: [
                        [$class: 'FailedThreshold',
                            failureNewThreshold: '3',
                            failureThreshold: '15',
                            unstableNewThreshold: '99999',
                            unstableThreshold: '99999'],
                        [$class: 'SkippedThreshold',
                            failureNewThreshold: '99999',
                            failureThreshold: '99999',
                            unstableNewThreshold: '99999',
                            unstableThreshold: '99999']],
                    tools: [[$class: 'JUnitType',
                                deleteOutputFiles: true,
                                failIfNotNew: true,
                                pattern: 'TEST-*.xml',
                                skipNoTestFiles: false,
                                stopProcessingIfError: true]]])
            }
        }
    }
    stage "Parallel test run"
    timestamps {
        parallel test_runs
    }

    if (is_pr) {
        if (currentBuild.result == 'SUCCESS') {
            setGitHubPullRequestStatus state: 'SUCCESS', context: "${env.JOB_NAME}", message: 'Build finished successfully'
        } else {
            setGitHubPullRequestStatus state: 'FAILURE', context: "${env.JOB_NAME}", message: "Build failed"
        }
    }
} catch (Exception e) {
    echo "Error: ${e}"
    if (is_pr) {
        setGitHubPullRequestStatus state: 'FAILURE', context: "${env.JOB_NAME}", message: "Build failed: ${e}"
    }
    throw e
} finally {
    echo "Finally"
}


echo "End of pipeline"

// Support functions:
def build_proxy_args() {
    return ["--build-arg http_proxy=${env.http_proxy}",
            "--build-arg https_proxy=${env.https_proxy}",
            "--build-arg ALL_PROXY=${env.ALL_PROXY}"].join(" ")
}

def run_proxy_args() {
    return [ "-e http_proxy=${env.http_proxy}",
             "-e https_proxy=${env.https_proxy}",
             "-e ALL_PROXY=${env.ALL_PROXY}",
             "-e no_proxy=${env.NO_PROXY}"].join(" ")
}

def build_user_args() {
    dir(pwd([tmp:true])+"/.build_user_args") {
         // get jenkins user uid/gid
        sh "id -u > jenkins_uid"
        jenkins_uid = readFile("jenkins_uid").trim()
        sh "id -g > jenkins_gid"
        jenkins_gid = readFile("jenkins_gid").trim()
        deleteDir()
    }
    return "--build-arg uid=${jenkins_uid} --build-arg gid=${jenkins_gid}"
}
