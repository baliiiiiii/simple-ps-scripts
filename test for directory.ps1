#These scripts have been modified to have some pseudocodey parts. I've removed
#as little as possible to keep it as accurate as I can while still maintaining security.

#This was my first PowerShell script I ever made! :)


if(test-path C:\Data)
{
	write-output "hello"
}else
{
	cd C:\
	mkdir Data
}