#
# METADATA
# description: >-
#   Sanity checks related to the format of the image build's attestation.
#
package policy.release.attestation_type

import future.keywords.contains
import future.keywords.if
import future.keywords.in

import data.lib

exception contains rules if {
	count(lib.pipelinerun_attestations) == 0
	rules := ["known_attestation_type"]
}

# METADATA
# title: Known attestation type found
# description: >-
#   A sanity check to confirm the attestation found for the image has a known
#   attestation type.
# custom:
#   short_name: known_attestation_type
#   failure_msg: Unknown attestation type '%s'
#   solution: >-
#     Make sure the "_type" field in the attestation is supported. Supported types are configured
#     in xref:ec-cli:ROOT:configuration.adoc#_data_sources[data sources].
#   collections:
#   - minimal
#
deny_known_attestation_type contains result if {
	some att in lib.pipelinerun_attestations
	att_type := att._type
	not att_type in lib.rule_data("known_attestation_types")
	result := lib.result_helper(rego.metadata.chain(), [att_type])
}

# METADATA
# title: PipelineRun attestation found
# description: >-
#   At least one PipelineRun attestation must be present.
# custom:
#   short_name: pipelinerun_attestation_found
#   failure_msg: Missing pipelinerun attestation
#   solution: >-
#     Make sure the attestation being verified was generated from a Tekton pipelineRun.
#   collections:
#   - minimal
#
deny_pipelinerun_attestation_found contains result if {
	count(lib.pipelinerun_attestations) == 0
	result := lib.result_helper(rego.metadata.chain(), [])
}
