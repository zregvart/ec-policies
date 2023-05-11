#
# METADATA
# title: Task bundle checks
# description: >-
#   To be able to reproduce and audit builds accurately it's important
#   to know exactly what happened during the build. To do this
#   Enterprise Contract requires that all tasks are defined in a set of
#   known and trusted task bundles. This package includes rules to
#   confirm that the tasks that built the image were defined in task
#   bundles, and that the task bundles used are from the list of known
#   and trusted bundles.
#
package policy.release.attestation_task_bundle

import future.keywords.contains
import future.keywords.if

import data.lib
import data.lib.bundles

exception contains rules if {
	count(lib.tasks_from_pipelinerun) == 0
	rules := ["tasks_defined_in_bundle", "task_ref_bundles_not_empty", "task_ref_bundles_acceptable", "acceptable_bundles_provided", "task_ref_bundles_current", "task_ref_bundles_pinned"]
}

# METADATA
# title: Tasks defined using bundle references
# description: >-
#   Check for existence of a task bundle. Enforcing this rule will
#   fail the contract if the task is not called from a bundle.
# custom:
#   short_name: tasks_defined_in_bundle
#   failure_msg: Pipeline task '%s' does not contain a bundle reference
#   collections:
#   - minimal
#
deny_tasks_defined_in_bundle contains result if {
	name := bundles.disallowed_task_reference(lib.tasks_from_pipelinerun)[_].name
	result := lib.result_helper(rego.metadata.chain(), [name])
}

# METADATA
# title: Task bundle references not empty
# description: >-
#   Check for a valid task bundle reference being used.
# custom:
#   short_name: task_ref_bundles_not_empty
#   failure_msg: Pipeline task '%s' uses an empty bundle image reference
#   solution: >-
#     Specify a task bundle with a reference as the full digest.
#   collections:
#   - minimal
#
deny_task_ref_bundles_not_empty contains result if {
	name := bundles.empty_task_bundle_reference(lib.tasks_from_pipelinerun)[_].name
	result := lib.result_helper(rego.metadata.chain(), [name])
}

# METADATA
# title: Task bundle references pinned to digest
# description: >-
#   Check if the Tekton Bundle used for the Tasks in the Pipeline definition
#   is pinned to a digest.
# custom:
#   short_name: task_ref_bundles_pinned
#   failure_msg: Pipeline task '%s' uses an unpinned task bundle reference '%s'
#   solution: >-
#     Specify the task bundle reference with a full digest rather than a tag.
#
warn_task_ref_bundles_pinned contains result if {
	task := bundles.unpinned_task_bundle(lib.tasks_from_pipelinerun)[_]
	result := lib.result_helper(rego.metadata.chain(), [task.name, bundles.bundle(task)])
}

# METADATA
# title: Task bundles are latest versions
# description: >-
#   For each Task in the SLSA Provenance attestation, check if the Tekton Bundle used is
#   the most recent xref:acceptable_bundles.adoc#_task_bundles[acceptable bundle].
# custom:
#   short_name: task_ref_bundles_current
#   failure_msg: Pipeline task '%s' uses an out of date task bundle '%s'
#   solution: >-
#     A task bundle used is not the most recent. The most recent task bundles are defined
#     as in xref:acceptable_bundles.adoc#_task_bundles[acceptable bundles] list.
#
warn_task_ref_bundles_current contains result if {
	task := bundles.out_of_date_task_bundle(lib.tasks_from_pipelinerun)[_]
	result := lib.result_helper(rego.metadata.chain(), [task.name, bundles.bundle(task)])
}

# METADATA
# title: Task bundles are in acceptable bundles list
# description: >-
#   For each Task in the SLSA Provenance attestation, check if the Tekton Bundle used is
#   an xref:acceptable_bundles.adoc#_task_bundles[acceptable bundle] given the tracked
#   effective_on date.
# custom:
#   short_name: task_ref_bundles_acceptable
#   failure_msg: Pipeline task '%s' uses an unacceptable task bundle '%s'
#   solution: >-
#     For each Task in the SLSA Provenance attestation, check if the Tekton Bundle used is
#     an xref:acceptable_bundles.adoc#_task_bundles[acceptable bundle].
#
deny_task_ref_bundles_acceptable contains result if {
	task := bundles.unacceptable_task_bundle(lib.tasks_from_pipelinerun)[_]
	result := lib.result_helper(rego.metadata.chain(), [task.name, bundles.bundle(task)])
}

# METADATA
# title: An acceptable Tekton bundles list was provided
# description: >-
#   The policy rules in this package require the acceptable Tekton task bundles
#   rule data to be provided.
# custom:
#   short_name: acceptable_bundles_provided
#   failure_msg: Missing required task-bundles data
#   solution: >-
#     Create an acceptable bundles list. This is a list of task bundles with a top-level key
#     of 'task-bundles'. More information can be found at
#     xref:acceptable_bundles.adoc#_task_bundles[acceptable bundles].
deny_acceptable_bundles_provided contains result if {
	bundles.missing_task_bundles_data
	result := lib.result_helper(rego.metadata.chain(), [])
}
