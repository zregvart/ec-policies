package release.cve

import rego.v1

# converted from https://github.com/quay/clair/blob/main/openapi.yaml at
# revision 0a3a4611964014c0c9846d8c79acdd062af9c17d using typeconv
# (https://github.com/grantila/typeconv/):
#
# npx typeconv -f oapi -t jsc openapi.yaml
_clair_schema_converted := {
	"definitions": {
		"Page": {},
		"PagedNotifications": {
			"type": "object",
			"properties": {
				"page": {
					"type": "object",
					"description": "A page object informing the client the next page to retrieve. If page.next becomes \"-1\" the client should stop paging.",
				},
				"notifications": {
					"type": "array",
					"items": {"$ref": "#/definitions/Notification"},
					"description": "A list of notifications within this page",
				},
			},
			"title": "PagedNotifications",
			"description": "A page object followed by a list of notifications",
		},
		"Callback": {
			"type": "object",
			"properties": {
				"notification_id": {
					"type": "string",
					"description": "the unique identifier for this set of notifications",
				},
				"callback": {
					"type": "string",
					"description": "the url where notifications can be retrieved",
				},
			},
			"title": "Callback",
			"description": "A callback for clients to retrieve notifications",
		},
		"VulnSummary": {
			"type": "object",
			"properties": {
				"name": {
					"type": "string",
					"description": "the vulnerability name",
				},
				"fixed_in_version": {
					"type": "string",
					"description": "The version which the vulnerability is fixed in. Empty if not fixed.",
				},
				"links": {
					"type": "string",
					"description": "links to external information about vulnerability",
				},
				"description": {
					"type": "string",
					"description": "the vulnerability name",
				},
				"normalized_severity": {
					"type": "string",
					"enum": [
						"Unknown",
						"Negligible",
						"Low",
						"Medium",
						"High",
						"Critical",
					],
					"description": "A well defined set of severity strings guaranteed to be present.",
				},
				"package": {"$ref": "#/definitions/Package"},
				"distribution": {"$ref": "#/definitions/Distribution"},
				"repository": {"$ref": "#/definitions/Repository"},
			},
			"title": "VulnSummary",
			"description": "A summary of a vulnerability",
		},
		"Notification": {
			"type": "object",
			"properties": {
				"id": {
					"type": "string",
					"description": "a unique identifier for this notification",
				},
				"manifest": {
					"type": "string",
					"description": "The hash of the manifest affected by the provided vulnerability.",
				},
				"reason": {
					"type": "string",
					"description": "the reason for the notifcation, [added | removed]",
				},
				"vulnerability": {"$ref": "#/definitions/VulnSummary"},
			},
			"title": "Notification",
			"description": "A notification expressing a change in a manifest affected by a vulnerability.",
		},
		"Environment": {
			"type": "object",
			"properties": {
				"package_db": {
					"type": "string",
					"description": "The filesystem path or unique identifier of a package database.",
				},
				"introduced_in": {"$ref": "#/definitions/Digest"},
				"distribution_id": {
					"type": "string",
					"description": "The distribution ID found in an associated IndexReport or VulnerabilityReport.",
				},
			},
			"required": [
				"package_db",
				"introduced_in",
				"distribution_id",
			],
			"title": "Environment",
			"description": "The environment a particular package was discovered in.",
		},
		"IndexReport": {
			"type": "object",
			"properties": {
				"manifest_hash": {"$ref": "#/definitions/Digest"},
				"state": {
					"type": "string",
					"description": "The current state of the index operation",
				},
				"packages": {
					"type": "object",
					"additionalProperties": {"$ref": "#/definitions/Package"},
					"description": "A map of Package objects indexed by Package.id",
				},
				"distributions": {
					"type": "object",
					"additionalProperties": {"$ref": "#/definitions/Distribution"},
					"description": "A map of Distribution objects keyed by their Distribution.id discovered in the manifest.",
				},
				"environments": {
					"type": "object",
					"additionalProperties": {
						"type": "array",
						"items": {"$ref": "#/definitions/Environment"},
					},
					"description": "A map of lists containing Environment objects keyed by the associated Package.id.",
				},
				"success": {
					"type": "boolean",
					"description": "A bool indicating succcessful index",
				},
				"err": {
					"type": "string",
					"description": "An error message on event of unsuccessful index",
				},
			},
			"required": [
				"manifest_hash",
				"state",
				"packages",
				"distributions",
				"environments",
				"success",
				"err",
			],
			"title": "IndexReport",
			"description": "A report of the Index process for a particular manifest. A client's usage of this is largely information. Clair uses this report for matching Vulnerabilities.",
		},
		"VulnerabilityReport": {
			"type": "object",
			"properties": {
				"manifest_hash": {"$ref": "#/definitions/Digest"},
				"packages": {
					"type": "object",
					"additionalProperties": {"$ref": "#/definitions/Package"},
					"description": "A map of Package objects indexed by Package.id",
				},
				"distributions": {
					"type": "object",
					"additionalProperties": {"$ref": "#/definitions/Distribution"},
					"description": "A map of Distribution objects indexed by Distribution.id.",
				},
				"environments": {
					"type": "object",
					"additionalProperties": {
						"type": "array",
						"items": {"$ref": "#/definitions/Environment"},
					},
					"description": "A mapping of Environment lists indexed by Package.id",
				},
				"vulnerabilities": {
					"type": "object",
					"additionalProperties": {"$ref": "#/definitions/Vulnerability"},
					"description": "A map of Vulnerabilities indexed by Vulnerability.id",
				},
				"package_vulnerabilities": {},
			},
			"required": [
				"manifest_hash",
				"packages",
				"distributions",
				"environments",
				"vulnerabilities",
				"package_vulnerabilities",
			],
			"title": "VulnerabilityReport",
			"description": "A report expressing discovered packages, package environments, and package vulnerabilities within a Manifest.",
		},
		"Vulnerability": {
			"type": "object",
			"properties": {
				"id": {
					"type": "string",
					"description": "A unique ID representing this vulnerability.",
				},
				"updater": {
					"type": "string",
					"description": "A unique ID representing this vulnerability.",
				},
				"name": {
					"type": "string",
					"description": "Name of this specific vulnerability.",
				},
				"description": {
					"type": "string",
					"description": "A description of this specific vulnerability.",
				},
				"links": {
					"type": "string",
					"description": "A space separate list of links to any external information.",
				},
				"severity": {
					"type": "string",
					"description": "A severity keyword taken verbatim from the vulnerability source.",
				},
				"normalized_severity": {
					"type": "string",
					"enum": [
						"Unknown",
						"Negligible",
						"Low",
						"Medium",
						"High",
						"Critical",
					],
					"description": "A well defined set of severity strings guaranteed to be present.",
				},
				"package": {"$ref": "#/definitions/Package"},
				"distribution": {"$ref": "#/definitions/Distribution"},
				"repository": {"$ref": "#/definitions/Repository"},
				"issued": {
					"type": "string",
					"description": "The timestamp in which the vulnerability was issued",
				},
				"range": {
					"type": "string",
					"description": "The range of package versions affected by this vulnerability.",
				},
				"fixed_in_version": {
					"type": "string",
					"description": "A unique ID representing this vulnerability.",
				},
			},
			"required": [
				"id",
				"updater",
				"name",
				"description",
				"links",
				"severity",
				"normalized_severity",
				"fixed_in_version",
			],
			"title": "Vulnerability",
			"description": "A unique vulnerability indexed by Clair",
		},
		"Distribution": {
			"type": "object",
			"properties": {
				"id": {
					"type": "string",
					"description": "A unique ID representing this distribution",
				},
				"did": {"type": "string"},
				"name": {"type": "string"},
				"version": {"type": "string"},
				"version_code_name": {"type": "string"},
				"version_id": {"type": "string"},
				"arch": {"type": "string"},
				"cpe": {"type": "string"},
				"pretty_name": {"type": "string"},
			},
			"required": [
				"id",
				"did",
				"name",
				"version",
				"version_code_name",
				"version_id",
				"arch",
				"cpe",
				"pretty_name",
			],
			"title": "Distribution",
			"description": "An indexed distribution discovered in a layer. See https://www.freedesktop.org/software/systemd/man/os-release.html for explanations and example of fields.",
		},
		"SourcePackage": {
			"type": "object",
			"properties": {
				"id": {
					"type": "string",
					"description": "A unique ID representing this package",
				},
				"name": {
					"type": "string",
					"description": "Name of the Package",
				},
				"version": {
					"type": "string",
					"description": "Version of the Package",
				},
				"kind": {
					"type": "string",
					"description": "Kind of package. Source | Binary",
				},
				"source": {"type": "string"},
				"normalized_version": {"$ref": "#/definitions/Version"},
				"arch": {"type": "string"},
				"module": {"type": "string"},
				"cpe": {
					"type": "string",
					"description": "A CPE identifying the package",
				},
			},
			"required": [
				"id",
				"name",
				"version",
			],
			"title": "SourcePackage",
			"description": "A source package affiliated with a Package",
		},
		"Package": {
			"type": "object",
			"properties": {
				"id": {
					"type": "string",
					"description": "A unique ID representing this package",
				},
				"name": {
					"type": "string",
					"description": "Name of the Package",
				},
				"version": {
					"type": "string",
					"description": "Version of the Package",
				},
				"kind": {
					"type": "string",
					"description": "Kind of package. Source | Binary",
				},
				"source": {"$ref": "#/definitions/SourcePackage"},
				"normalized_version": {"$ref": "#/definitions/Version"},
				"arch": {
					"type": "string",
					"description": "The package's target system architecture",
				},
				"module": {
					"type": "string",
					"description": "A module further defining a namespace for a package",
				},
				"cpe": {
					"type": "string",
					"description": "A CPE identifying the package",
				},
			},
			"required": [
				"id",
				"name",
				"version",
			],
			"title": "Package",
			"description": "A package discovered by indexing a Manifest",
		},
		"Repository": {
			"type": "object",
			"properties": {
				"id": {"type": "string"},
				"name": {"type": "string"},
				"key": {"type": "string"},
				"uri": {"type": "string"},
				"cpe": {"type": "string"},
			},
			"title": "Repository",
			"description": "A package repository",
		},
		"Version": {
			"type": "string",
			"title": "Version",
			"description": "Version is a normalized claircore version, composed of a \"kind\" and an array of integers such that two versions of the same kind have the correct ordering when the integers are compared pair-wise.",
		},
		"Manifest": {
			"type": "object",
			"properties": {
				"hash": {"$ref": "#/definitions/Digest"},
				"layers": {
					"type": "array",
					"items": {"$ref": "#/definitions/Layer"},
				},
			},
			"required": [
				"hash",
				"layers",
			],
			"title": "Manifest",
			"description": "A Manifest representing a container. The 'layers' array must preserve the original container's layer order for accurate usage.",
		},
		"Layer": {
			"type": "object",
			"properties": {
				"hash": {"$ref": "#/definitions/Digest"},
				"uri": {
					"type": "string",
					"description": "A URI describing where the layer may be found. Implementations MUST support http(s) schemes and MAY support additional schemes.",
				},
				"headers": {
					"type": "object",
					"additionalProperties": {
						"type": "array",
						"items": {"type": "string"},
					},
					"description": "map of arrays of header values keyed by header value. e.g. map[string][]string",
				},
			},
			"required": [
				"hash",
				"uri",
				"headers",
			],
			"title": "Layer",
			"description": "A Layer within a Manifest and where Clair may retrieve it.",
		},
		"BulkDelete": {
			"type": "array",
			"items": {"$ref": "#/definitions/Digest"},
			"title": "BulkDelete",
			"description": "An array of Digests to be deleted.",
		},
		"Error": {
			"type": "object",
			"properties": {
				"code": {
					"type": "string",
					"description": "a code for this particular error",
				},
				"message": {
					"type": "string",
					"description": "a message with further detail",
				},
			},
			"title": "Error",
			"description": "A general error schema returned when status is not 200 OK",
		},
		"State": {
			"type": "object",
			"properties": {"state": {
				"type": "string",
				"description": "an opaque identifier",
			}},
			"required": ["state"],
			"title": "State",
			"description": "an opaque identifier",
		},
		"Digest": {
			"type": "string",
			"title": "Digest",
			"description": "A digest string with prefixed algorithm. The format is described here: https://github.com/opencontainers/image-spec/blob/master/descriptor.md#digests\nDigests are used throughout the API to identify Layers and Manifests.",
		},
	},
	"$id": "openapi.json",
	"$comment": "Generated from openapi.yaml by core-types-json-schema (https://github.com/grantila/core-types-json-schema) on behalf of typeconv (https://github.com/grantila/typeconv)",
}

_clair_schema := object.union(
    _clair_schema_converted,
    {
        "$ref": "#/definitions/VulnerabilityReport"
    }
)