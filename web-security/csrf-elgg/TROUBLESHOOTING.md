# Troubleshooting

If you previously executed one of the labs (say, XSS-Elgg), you may experience the following error when running another lab (say, CSRF-Elgg):

```
Creating mysql-10.9.0.6 ... error

ERROR: for mysql-10.9.0.6  Cannot create container for service mysql: Conflict. The container name "/mysql-10.9.0.6" is already in use by container "88489d13370b9ab25226e065b5869d3fb7d82e3819dcb0df1108bf2f190fb08d". You have to remove (or rename) that container to be able to reuse that name.
```

This error may be due to residual resources from previous executions. To fix the issue:

1. Bring down all of the labs with `docker-compose down`
2. Check if there is any container still running, with `docker ps`
3. Kill any running container, with `docker kill <PID>` (using the PIDs listed by the previous command)
4. Run `docker container prune`
5. Run `docker network prune`

