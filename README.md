# Polling for status with a timeout

This action makes a GET request to a given URL until the status is `finished` or `error`
Used after launching an action that executes asynchronously and polling for that action's status
Initially created for checking if a kubernetes deployment is complete

## Inputs

### `url`

The URL to poll

### `timeout`

Timeout before giving up in seconds

### `interval`

Interval between polling in seconds

## Example usage
```
uses: EPFL-ENAC/poll_cd_status@v0.2.0
with:
  url: "https://www.example.com/deployments/1"
  timeout: 20
  interval: 5
```

This script expects a json response from the polling url in the following format:

```
{
  status: "finished" | "error"
}
```

Script exit with 1 when status is `error` and 0 when `finished`
Exit with 1 if timeout reached before receiving `error` or `finished` as status