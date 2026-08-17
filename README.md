# Linux Administration and Automated Backups

Basic Linux system administration and backup automation implemented on an Ubuntu 26.04 LTS virtual machine running in Oracle VirtualBox.

The project covers user and group management, shared-directory permissions, SGID-based group inheritance, Bash scripting, and scheduled backups using cron.

---

## Overview

The environment was created as a local Ubuntu 26.04 LTS virtual machine in Oracle VirtualBox.

The implementation included:

- Ubuntu environment setup and system updates.
- User and group administration.
- Shared-directory creation.
- Ownership and permission management.
- SGID configuration for group inheritance.
- Bash-based backup automation.
- Daily scheduling with `cron`.
- Manual validation of the generated backup.

> The project evidence corresponds to an Ubuntu 26.04 LTS Desktop ISO. The repository therefore refers to the environment as Ubuntu 26.04 LTS rather than Ubuntu Server.

---

## Architecture

![Linux Administration and Automated Backup Architecture](images/architecture%20.png)

The environment follows this general structure:

```text
Host Machine
     │
     ▼
Oracle VirtualBox
     │
     ▼
Ubuntu 26.04 LTS VM
     │
     ├── Users
     │   ├── jdoe
     │   ├── asmith
     │   └── bwhite
     │
     ├── Groups
     │   ├── admin
     │   └── desarrolladores
     │
     ├── Shared Directories
     │   ├── /home/admin
     │   └── /home/proyectos
     │
     ├── Permissions
     │   ├── 770
     │   └── SGID
     │
     └── Backup Automation
         │
         ▼
       cron
         │
         │ Daily at 02:00
         ▼
 /usr/local/bin/respaldo_home.sh
         │
         ▼
 /var/backups/respaldo_home_YYYY-MM-DD.tar.gz
```

---

## Technologies and Tools

| Technology / Tool | Purpose |
|---|---|
| Ubuntu 26.04 LTS | Linux operating system environment |
| Oracle VirtualBox | Local virtualization platform |
| `adduser` | User creation |
| `groupadd` | Group creation |
| `usermod` | Group membership management |
| `chown` | Ownership configuration |
| `chmod` | Permission and SGID configuration |
| Bash | Backup scripting |
| `tar` + gzip | Archive creation and compression |
| cron | Scheduled backup execution |

---

## Virtual Machine Configuration

The virtual machine used during the project was configured with:

| Resource | Configuration |
|---|---|
| CPU | 5 cores |
| Memory | 4 GiB |
| Virtual disk | 30 GiB |
| Operating system | Ubuntu 26.04 LTS |
| Virtualization | Oracle VirtualBox |

---

## User and Group Management

Three users were used during the exercise:

| User | Role in the Exercise |
|---|---|
| `jdoe` | Administration |
| `asmith` | Development |
| `bwhite` | Development |

Two custom groups were created:

```bash
sudo groupadd admin
sudo groupadd desarrolladores
```

Users were then assigned to their corresponding groups:

```bash
sudo usermod -aG admin jdoe
sudo usermod -aG desarrolladores asmith
sudo usermod -aG desarrolladores bwhite
```

Membership was verified using:

```bash
groups jdoe
groups asmith
groups bwhite
```

The `/etc/group` file was also inspected to confirm the group configuration.

> The custom `admin` group represents the administrative role used in the exercise. Membership in this group does not automatically grant `sudo` privileges.

---

## Shared Directories and Permissions

Two shared directories were created:

```bash
sudo mkdir /home/proyectos
sudo mkdir /home/admin
```

### Project Directory

The `/home/proyectos` directory was assigned to the `desarrolladores` group:

```bash
sudo chown :desarrolladores /home/proyectos
sudo chmod 770 /home/proyectos
```

### Administrative Directory

The `/home/admin` directory was assigned to the custom `admin` group:

```bash
sudo chown :admin /home/admin
sudo chmod 770 /home/admin
```

The `770` permission mode grants full access to the owner and group while denying access to other users.

---

## SGID Group Inheritance

The SGID bit was enabled on both shared directories:

```bash
sudo chmod g+s /home/proyectos
sudo chmod g+s /home/admin
```

This causes new files and subdirectories created inside these locations to inherit the group ownership of the parent directory.

The resulting permissions were verified with output similar to:

```text
drwxrws---
```

where the `s` in the group execution position confirms that SGID is enabled.

---

## Automated Backup Script

A Bash script was created at:

```text
/usr/local/bin/respaldo_home.sh
```

The original script used during the implementation is included in this repository:

**[`scripts/respaldo_home.sh`](scripts/respaldo_home.sh)**

Its main command is:

```bash
tar -czf /var/backups/respaldo_home_$(date +%F).tar.gz /home
```

This command:

- creates a new archive with `tar`;
- compresses it using gzip;
- stores the result in `/var/backups`;
- backs up the `/home` directory;
- includes the execution date in the filename.

Example output:

```text
/var/backups/respaldo_home_2026-05-06.tar.gz
```

The date-based filename keeps backups from different dates separate. Multiple executions on the same day would use the same filename and could overwrite that day's previous backup.

---

## Script Permissions

Execution permission was assigned with:

```bash
sudo chmod +x /usr/local/bin/respaldo_home.sh
```

---

## Cron Automation

The backup script was scheduled using root's crontab:

```bash
sudo crontab -e
```

The configured cron entry was:

```cron
0 2 * * * /usr/local/bin/respaldo_home.sh
```

This executes the backup script every day at:

```text
02:00 AM
```

Using root's crontab is consistent with storing backups under `/var/backups` and accessing the contents of `/home`.

---

## Backup Validation

The script was first executed manually:

```bash
sudo /usr/local/bin/respaldo_home.sh
```

The contents of the backup directory were then inspected and the generated archive was confirmed:

```text
respaldo_home_2026-05-06.tar.gz
```

This validates that the backup file was created successfully.

The project did not include a full restoration or archive-integrity test, so the evidence confirms backup creation rather than complete disaster-recovery validation.

---

## Implementation Flow

```text
Create Ubuntu VM
        │
        ▼
Update the system
        │
        ▼
Create users and groups
        │
        ▼
Assign group memberships
        │
        ▼
Create shared directories
        │
        ▼
Configure ownership and 770 permissions
        │
        ▼
Enable SGID group inheritance
        │
        ▼
Create respaldo_home.sh
        │
        ▼
Grant execution permission
        │
        ▼
Schedule daily execution with cron
        │
        ▼
Generate backup in /var/backups
        │
        ▼
Verify generated archive
```

---

## Technical Report

The complete implementation process, commands, screenshots, configuration evidence, and conclusions are available in the technical report:

**[View Technical Report](report/linux-system-administration-report.pdf)**

The report contains evidence of:

- VirtualBox configuration.
- Ubuntu installation and updates.
- User and group management.
- Group membership verification.
- Shared-directory permissions.
- SGID configuration.
- Backup script creation.
- Cron scheduling.
- Generated backup validation.

---

## Key Learnings

This project reinforced several core Linux system-administration concepts:

- Users and groups provide a foundation for access control.
- File ownership and permission modes define how shared resources can be accessed.
- SGID helps preserve group ownership inside collaborative directories.
- Existing Linux tools can be combined to automate recurring administrative tasks.
- Bash and cron provide a simple foundation for backup automation.
- Backup creation should be verified rather than assumed.
- Technical documentation is useful for maintenance, auditing, troubleshooting, and future improvements.

---

## Possible Improvements

Future extensions could include:

- backup integrity verification;
- automated restoration testing;
- backup retention and rotation policies;
- off-host or remote backup storage;
- logging and failure notifications;
- encryption of backup archives;
- more granular access-control policies.

These improvements were outside the scope of the current project.

---

## Repository Structure

```text
linux-system-administration-backups/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── scripts/
│   └── respaldo_home.sh
│
├── report/
│   └── linux-system-administration-report.pdf
│
└── images/
    └── architecture.png
```

---

## Project Status

**Completed**

The project successfully implemented user and group administration, shared-directory permissions, SGID inheritance, and automated daily backups in a virtualized Ubuntu environment.
