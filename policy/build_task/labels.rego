#
# METADATA
# title: Tekton task build type label checks
# description: >-
#   Policies to verify that a Tekton build task definition has the
#   required build type label.
#
package policy.build_task.labels

import future.keywords.contains
import future.keywords.if
import future.keywords.in

import data.lib
import data.lib.tkn

build_label := "build.appstudio.redhat.com/build_type"

# METADATA
# title: Build task has build type label
# description: >-
#   Confirm the build task definition has the required build type label.
# custom:
#   short_name: build_type_label_set
#   failure_msg: The required build label '%s' is missing
#
deny contains result if {
	not build_label in object.keys(tkn.task_labels)
	result := lib.result_helper(rego.metadata.chain(), [build_label])
}

# METADATA
# title: Build task has label
# description: >-
#   Confirm that the build task definition includes at least one label.
# custom:
#   short_name: build_task_has_label
#   failure_msg: The task definition does not include any labels
#
deny contains result if {
	not tkn.task_labels
	result := lib.result_helper(rego.metadata.chain(), [])
}
