# spot

## Private dependency: subway_inputs

Geofence data comes from the private
[`mbta/subway_inputs`](https://github.com/mbta/subway_inputs) repo, pulled in as
a Mix git dependency over HTTPS.

### Local setup

`mix deps.get` needs HTTPS access to the repo. Authenticate with the GitHub CLI:

    gh auth login
    gh auth setup-git

### Updating the data

Regenerate the JSON in a `subway_inputs` checkout (see its README), merge it,
then in spot run `mix deps.update subway_inputs` and commit `mix.lock`.

### CI and deploys

Workflows authenticate with the `SUBWAY_INPUTS_ACCESS_TOKEN` repository secret.
