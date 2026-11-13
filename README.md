# spot

## Private dependency: subway_inputs

Geofence data comes from the private
[`mbta/subway_inputs`](https://github.com/mbta/subway_inputs) repo, pulled in as
a Mix git dependency over HTTPS.

### Local setup

Make sure git can authenticate to GitHub over HTTPS (for example `gh
auth login`, then `gh auth setup-git`) to ensure that `mix deps.get` runs
successfully.

### Updating the data

Regenerate the JSON in a `subway_inputs` checkout (see its README), merge it,
then in spot run `mix deps.update subway_inputs` and commit `mix.lock`.

### CI and deploys

Workflows authenticate with the `SUBWAY_INPUTS_ACCESS_TOKEN` repository secret.
