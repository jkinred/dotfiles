export PIPENV_VENV_IN_PROJECT=1

# Shell aliases to set AWS context (i.e. profile, MFA)
for context in $(aws-vault list --profiles); do
    alias ${context}="aws-vault exec ${context}";
done

function prod-ssm-init() {
    cpr ssm-diff -f parameters-prod.yaml init
    cp parameters-prod.yaml parameters-prod_$(date -u +"%Y-%m-%dT%H:%M:%SZ").yaml
}

function nonprod-ssm-init() {
    cnp ssm-diff -f parameters-nonprod.yaml init
    cp parameters-nonprod.yaml parameters-nonprod_$(date -u +"%Y-%m-%dT%H:%M:%SZ").yaml
}

function prod-ssm-plan() {
    cpr ssm-diff -f parameters-prod.yaml plan
}

function nonprod-ssm-plan() {
    cnp ssm-diff -f parameters-nonprod.yaml plan
}

function prod-ssm-apply() {
    cpr ssm-diff -f parameters-prod.yaml apply
}

function nonprod-ssm-apply() {
    cnp ssm-diff -f parameters-nonprod.yaml apply
}
