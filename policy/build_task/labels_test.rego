package policy.build_task.labels

import data.lib

test_build_label_found {
	lib.assert_empty(deny) with input as {"metadata": {"labels": {"build.appstudio.redhat.com/build_type": "docker"}}}
}

test_build_label_not_found {
	lib.assert_equal_results(deny, {{
		"code": "labels.build_type_label_set",
		"msg": "The required build label 'build.appstudio.redhat.com/build_type' is missing",
	}}) with input as {"metadata": {"labels": {"bad": "docker"}}}
}

test_no_labels {
	lib.assert_equal_results(deny, {{
		"code": "labels.build_task_has_label",
		"msg": "The task definition does not include any labels",
	}}) with input as {"metadata": {"name": "no_labels"}}
}
