# Creating Terraform Output
This is a simple [Bash](https://www.gnu.org/software/bash/) script that reads through your [Terraform](https://terraform.io) [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) code and spits out syntax compliant `terraform output` code. Using this script eases maintaining output stanzas, ensures you don't miss a new resource and eliminates needing to remove obsolete outputs. Every resources will have a output created that returns it's ID (not ARN) for the related service.

`create-terrafrom-output.sh` accepts only one command, `plan`, and a single path passed presently; ie: `create-terrafrom-output.sh plan <path_to_.tf_files>`. The resulting code is printed to stdout. This is convenient as you can review the code first and then pipe it to a file to be included in the next `terrafrom apply`. Script errors are conveniently printed to stderr so that you can see them even when piping stdout. Running the script dry will print out it's help.

## Requirements
- Terrafrom client
- Bash

> Tested on Mac OS 10.11.4 and Ubuntu 14.04 LTS.

## Example Usage
```bash
$ ./create-terrafrom-output.sh plan . > outputs.tf
$ terraform apply
$ terraform output
```
`create-terrafrom-output.sh` can also be used with local modules.
```bash
$ ./create-terrafrom-output.sh plan path_to_local_module > path_to_local_module/outputs.tf
$ terraform get
$ terraform apply
$ terraform output -module <name of module>
```
