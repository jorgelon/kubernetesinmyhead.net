# Tips

## A virtual machine is stuck powering off

Identify the Id of the vm via powershell

```powershell
get-vm | ft VMName, VMId
```

Then got to task manager to see the processes. Under the "command line" column, end the virtual machine process (vmwp.exe) that has the VMId as parameter
