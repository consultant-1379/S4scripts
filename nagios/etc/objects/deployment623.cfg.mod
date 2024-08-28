###############################################################################
# LOCALHOST.CFG - SAMPLE OBJECT CONFIG FILE FOR MONITORING THIS MACHINE
#
#
# NOTE: This config file is intended to serve as an *extremely* simple 
#       example of how you can create configuration entries to monitor
#       the local (Linux) machine.
#
###############################################################################


###############################################################################
###############################################################################
#
# HOST DEFINITION
#
###############################################################################
###############################################################################

# Define a host for the local machine

define host{
	use			linux-server
	host_name		ieatlms3901
	alias			623 deployment
	address			141.137.208.23
        contact_groups  	623admins
	}

#SVC Node

define host{
        use                     linux-server
        host_name               ieatrcxb4416
        alias                   svc-1
        address                 141.137.208.21
        contact_groups  	623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3804
        alias                   svc-2
        address                 141.137.208.11
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3914
        alias                   svc-3
        address                 141.137.208.18
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3805
        alias                   svc-4
        address                 141.137.208.12
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3776
        alias                   svc-5
        address                 141.137.208.7
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3806
        alias                   svc-6
        address                 141.137.208.13
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3777
        alias                   svc-7
        address                 141.137.208.8
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3807
        alias                   svc-8
        address                 141.137.208.14
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3778
        alias                   svc-9
        address                 141.137.208.9
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3911
        alias                   svc-10
        address                 141.137.208.15
       contact_groups  623admins
        }

#SCP

define host{
        use                     linux-server
        host_name               ieatrcxb2446
        alias                   scp-1
        address                 141.137.208.6
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb2445
        alias                   scp-2
        address                 141.137.208.5
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3839
        alias                   scp-3
        address                 141.137.208.19
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb6446
        alias                   scp-4
        address                 141.137.208.22
       contact_groups  623admins
        }

#DB

define host{
        use                     linux-server
        host_name               ieatrcxb3779
        alias                   db-1
        address                 141.137.208.10
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3912
        alias                   db-2
        address                 141.137.208.16
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3995
        alias                   db-3
        address                 141.137.208.20
       contact_groups  623admins
        }

define host{
        use                     linux-server
        host_name               ieatrcxb3913
        alias                   db-4
        address                 141.137.208.17
       contact_groups  623admins
        }

# Define Netsim #########################################################

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-01
        alias                   ieatnetsimv5116-01
        address                 10.151.192.175
	check_command		test!141.137.208.23!10.151.192.175
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-02
        alias                   ieatnetsimv5116-02
        address                 10.151.192.176
	check_command           test!141.137.208.23!10.151.192.176
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-03
        alias                   ieatnetsimv5116-03
        address                 10.151.192.177
        check_command           test!141.137.208.23!10.151.192.177
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-04
        alias                   ieatnetsimv5116-04
        address                 10.151.192.178
        check_command           test!141.137.208.23!10.151.192.178
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-05
        alias                   ieatnetsimv5116-05
        address                 10.151.192.179
        check_command           test!141.137.208.23!10.151.192.179
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-06
        alias                   ieatnetsimv5116-06
        address                 10.151.192.180
        check_command           test!141.137.208.23!10.151.192.180
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-07
        alias                   ieatnetsimv5116-07
        address                 10.151.192.181
        check_command           test!141.137.208.23!10.151.192.181
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-08
        alias                   ieatnetsimv5116-08
        address                 10.151.192.182
        check_command           test!141.137.208.23!10.151.192.182
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-09
        alias                   ieatnetsimv5116-09
        address                 10.151.192.183
        check_command           test!141.137.208.23!10.151.192.183
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-10
        alias                   ieatnetsimv5116-10
        address                 10.151.192.184
        check_command           test!141.137.208.23!10.151.192.184
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-11
        alias                   ieatnetsimv5116-11
        address                 10.151.192.185
        check_command           test!141.137.208.23!10.151.192.185
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-12
        alias                   ieatnetsimv5116-12
        address                 10.151.192.186
        check_command           test!141.137.208.23!10.151.192.186
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-13
        alias                   ieatnetsimv5116-13
        address                 10.151.192.187
        check_command           test!141.137.208.23!10.151.192.187
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-14
        alias                   ieatnetsimv5116-14
        address                 10.151.192.188
        check_command           test!141.137.208.23!10.151.192.188
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-15
        alias                   ieatnetsimv5116-15
        address                 10.151.192.189
        check_command           test!141.137.208.23!10.151.192.189
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-16
        alias                   ieatnetsimv5116-16
        address                 10.151.192.190
        check_command           test!141.137.208.23!10.151.192.190
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-17
        alias                   ieatnetsimv5116-17
        address                 10.151.192.191
        check_command           test!141.137.208.23!10.151.192.191
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-18
        alias                   ieatnetsimv5116-18
        address                 10.151.192.192
        check_command           test!141.137.208.23!10.151.192.192
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-19
        alias                   ieatnetsimv5116-19
        address                 10.151.192.193
        check_command           test!141.137.208.23!10.151.192.193
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-20
        alias                   ieatnetsimv5116-20
        address                 10.151.192.194
        check_command           test!141.137.208.23!10.151.192.194
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-21
        alias                   ieatnetsimv5116-21
        address                 10.151.192.195
        check_command           test!141.137.208.23!10.151.192.195
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-22
        alias                   ieatnetsimv5116-22
        address                 10.151.192.196
        check_command           test!141.137.208.23!10.151.192.196
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-23
        alias                   ieatnetsimv5116-23
        address                 10.151.192.197
        check_command           test!141.137.208.23!10.151.192.197
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-24
        alias                   ieatnetsimv5116-24
        address                 10.151.192.198
        check_command           test!141.137.208.23!10.151.192.198
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-25
        alias                   ieatnetsimv5116-25
        address                 10.151.192.199
        check_command           test!141.137.208.23!10.151.192.199
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-26
        alias                   ieatnetsimv5116-26
        address                 10.151.192.200
        check_command           test!141.137.208.23!10.151.192.200
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-27
        alias                   ieatnetsimv5116-27
        address                 10.151.192.201
        check_command           test!141.137.208.23!10.151.192.201
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-28
        alias                   ieatnetsimv5116-28
        address                 10.151.192.202
        check_command           test!141.137.208.23!10.151.192.202
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-29
        alias                   ieatnetsimv5116-29
        address                 10.151.192.203
        check_command           test!141.137.208.23!10.151.192.203
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-30
        alias                   ieatnetsimv5116-30
        address                 10.151.192.204
        check_command           test!141.137.208.23!10.151.192.204
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-31
        alias                   ieatnetsimv5116-31
        address                 10.151.192.205
        check_command           test!141.137.208.23!10.151.192.205
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-32
        alias                   ieatnetsimv5116-32
        address                 10.151.192.206
        check_command           test!141.137.208.23!10.151.192.206
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-33
        alias                   ieatnetsimv5116-33
        address                 10.151.192.207
        check_command           test!141.137.208.23!10.151.192.207
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-34
        alias                   ieatnetsimv5116-34
        address                 10.151.192.208
        check_command           test!141.137.208.23!10.151.192.208
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-35
        alias                   ieatnetsimv5116-35
        address                 10.151.192.209
        check_command           test!141.137.208.23!10.151.192.209
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-36
        alias                   ieatnetsimv5116-36
        address                 10.151.192.210
        check_command           test!141.137.208.23!10.151.192.210
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-37
        alias                   ieatnetsimv5116-37
        address                 10.151.192.211
        check_command           test!141.137.208.23!10.151.192.211
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-38
        alias                   ieatnetsimv5116-38
        address                 10.151.192.212
        check_command           test!141.137.208.23!10.151.192.212
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-39
        alias                   ieatnetsimv5116-39
        address                 10.151.192.213
        check_command           test!141.137.208.23!10.151.192.213
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-40
        alias                   ieatnetsimv5116-40
        address                 10.151.192.214
        check_command           test!141.137.208.23!10.151.192.214
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-41
        alias                   ieatnetsimv5116-41
        address                 10.151.192.215
        check_command           test!141.137.208.23!10.151.192.215
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-42
        alias                   ieatnetsimv5116-42
        address                 10.151.192.216
        check_command           test!141.137.208.23!10.151.192.216
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-43
        alias                   ieatnetsimv5116-43
        address                 10.151.192.217
        check_command           test!141.137.208.23!10.151.192.217
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-44
        alias                   ieatnetsimv5116-44
        address                 10.151.192.218
        check_command           test!141.137.208.23!10.151.192.218
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-45
        alias                   ieatnetsimv5116-45
        address                 10.151.192.219
        check_command           test!141.137.208.23!10.151.192.219
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-46
        alias                   ieatnetsimv5116-46
        address                 10.151.192.220
        check_command           test!141.137.208.23!10.151.192.220
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-47
        alias                   ieatnetsimv5116-47
        address                 10.151.192.221
        check_command           test!141.137.208.23!10.151.192.221
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-48
        alias                   ieatnetsimv5116-48
        address                 10.151.192.222
        check_command           test!141.137.208.23!10.151.192.222
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-49
        alias                   ieatnetsimv5116-49
        address                 10.151.192.223
        check_command           test!141.137.208.23!10.151.192.223
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-50
        alias                   ieatnetsimv5116-50
        address                 10.151.192.224
        check_command           test!141.137.208.23!10.151.192.224
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-51
        alias                   ieatnetsimv5116-51
        address                 10.151.192.225
        check_command           test!141.137.208.23!10.151.192.225
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-52
        alias                   ieatnetsimv5116-52
        address                 10.151.192.226
        check_command           test!141.137.208.23!10.151.192.226
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-53
        alias                   ieatnetsimv5116-53
        address                 10.151.192.227
        check_command           test!141.137.208.23!10.151.192.227
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-54
        alias                   ieatnetsimv5116-54
        address                 10.151.192.228
        check_command           test!141.137.208.23!10.151.192.228
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-55
        alias                   ieatnetsimv5116-55
        address                 10.151.192.229
        check_command           test!141.137.208.23!10.151.192.229
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-56
        alias                   ieatnetsimv5116-56
        address                 10.151.192.230
        check_command           test!141.137.208.23!10.151.192.230
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-57
        alias                   ieatnetsimv5116-57
        address                 10.151.192.231
        check_command           test!141.137.208.23!10.151.192.231
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-58
        alias                   ieatnetsimv5116-58
        address                 10.151.192.232
        check_command           test!141.137.208.23!10.151.192.232
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-59
        alias                   ieatnetsimv5116-59
        address                 10.151.192.233
        check_command           test!141.137.208.23!10.151.192.233
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-60
        alias                   ieatnetsimv5116-60
        address                 10.151.192.234
        check_command           test!141.137.208.23!10.151.192.234
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-61
        alias                   ieatnetsimv5116-61
        address                 10.151.192.235
        check_command           test!141.137.208.23!10.151.192.235
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-62
        alias                   ieatnetsimv5116-62
        address                 10.151.192.236
        check_command           test!141.137.208.23!10.151.192.236
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-63
        alias                   ieatnetsimv5116-63
        address                 10.151.192.237
        check_command           test!141.137.208.23!10.151.192.237
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-64
        alias                   ieatnetsimv5116-64
        address                 10.151.192.238
        check_command           test!141.137.208.23!10.151.192.238
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-65
        alias                   ieatnetsimv5116-65
        address                 10.151.192.239
        check_command           test!141.137.208.23!10.151.192.239
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-66
        alias                   ieatnetsimv5116-66
        address                 10.151.192.240
        check_command           test!141.137.208.23!10.151.192.240
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-67
        alias                   ieatnetsimv5116-67
        address                 10.151.192.241
        check_command           test!141.137.208.23!10.151.192.241
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-68
        alias                   ieatnetsimv5116-68
        address                 10.151.192.242
        check_command           test!141.137.208.23!10.151.192.242
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-69
        alias                   ieatnetsimv5116-69
        address                 10.151.192.243
        check_command           test!141.137.208.23!10.151.192.243
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-70
        alias                   ieatnetsimv5116-70
        address                 10.151.192.244
        check_command           test!141.137.208.23!10.151.192.244
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-71
        alias                   ieatnetsimv5116-71
        address                 10.151.192.245
        check_command           test!141.137.208.23!10.151.192.245
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-72
        alias                   ieatnetsimv5116-72
        address                 10.151.192.246
        check_command           test!141.137.208.23!10.151.192.246
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-73
        alias                   ieatnetsimv5116-73
        address                 10.151.192.247
        check_command           test!141.137.208.23!10.151.192.247
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-74
        alias                   ieatnetsimv5116-74
        address                 10.151.192.248
        check_command           test!141.137.208.23!10.151.192.248
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-75
        alias                   ieatnetsimv5116-75
        address                 10.151.192.249
        check_command           test!141.137.208.23!10.151.192.249
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-76
        alias                   ieatnetsimv5116-76
        address                 10.151.192.250
        check_command           test!141.137.208.23!10.151.192.250
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-77
        alias                   ieatnetsimv5116-77
        address                 10.151.192.251
        check_command           test!141.137.208.23!10.151.192.251
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-78
        alias                   ieatnetsimv5116-78
        address                 10.151.192.252
        check_command           test!141.137.208.23!10.151.192.252
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-79
        alias                   ieatnetsimv5116-79
        address                 10.151.192.253
        check_command           test!141.137.208.23!10.151.192.253
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-80
        alias                   ieatnetsimv5116-80
        address                 10.151.192.254
        check_command           test!141.137.208.23!10.151.192.254
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-81
        alias                   ieatnetsimv5116-81
        address                 10.151.192.255
        check_command           test!141.137.208.23!10.151.192.255
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-82
        alias                   ieatnetsimv5116-82
        address                 10.151.193.0
        check_command           test!141.137.208.23!10.151.193.0
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-83
        alias                   ieatnetsimv5116-83
        address                 10.151.193.1
        check_command           test!141.137.208.23!10.151.193.1
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-84
        alias                   ieatnetsimv5116-84
        address                 10.151.193.2
        check_command           test!141.137.208.23!10.151.193.2
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-85
        alias                   ieatnetsimv5116-85
        address                 10.151.193.3
        check_command           test!141.137.208.23!10.151.193.3
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-86
        alias                   ieatnetsimv5116-86
        address                 10.151.193.4
        check_command           test!141.137.208.23!10.151.193.4
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-87
        alias                   ieatnetsimv5116-87
        address                 10.151.193.5
        check_command           test!141.137.208.23!10.151.193.5
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-88
        alias                   ieatnetsimv5116-88
        address                 10.151.193.6
        check_command           test!141.137.208.23!10.151.193.6
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-89
        alias                   ieatnetsimv5116-89
        address                 10.151.193.7
        check_command           test!141.137.208.23!10.151.193.7
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-90
        alias                   ieatnetsimv5116-90
        address                 10.151.193.8
        check_command           test!141.137.208.23!10.151.193.8
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-91
        alias                   ieatnetsimv5116-91
        address                 10.151.193.9
        check_command           test!141.137.208.23!10.151.193.9
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-92
        alias                   ieatnetsimv5116-92
        address                 10.151.193.10
        check_command           test!141.137.208.23!10.151.193.10
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-93
        alias                   ieatnetsimv5116-93
        address                 10.151.193.11
        check_command           test!141.137.208.23!10.151.193.11
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-94
        alias                   ieatnetsimv5116-94
        address                 10.151.193.12
        check_command           test!141.137.208.23!10.151.193.12
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-95
        alias                   ieatnetsimv5116-95
        address                 10.151.193.63
        check_command           test!141.137.208.23!10.151.193.63
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-96
        alias                   ieatnetsimv5116-96
        address                 10.151.193.64
        check_command           test!141.137.208.23!10.151.193.64
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-97
        alias                   ieatnetsimv5116-97
        address                 10.151.193.65
        check_command           test!141.137.208.23!10.151.193.65
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-98
        alias                   ieatnetsimv5116-98
        address                 10.151.193.66
        check_command           test!141.137.208.23!10.151.193.66
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-99
        alias                   ieatnetsimv5116-99
        address                 10.151.193.67
        check_command           test!141.137.208.23!10.151.193.67
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-100
        alias                   ieatnetsimv5116-100
        address                 10.151.193.68
        check_command           test!141.137.208.23!10.151.193.68
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-101
        alias                   ieatnetsimv5116-101
        address                 10.151.193.69
        check_command           test!141.137.208.23!10.151.193.69
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-102
        alias                   ieatnetsimv5116-102
        address                 10.151.193.70
        check_command           test!141.137.208.23!10.151.193.70
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-103
        alias                   ieatnetsimv5116-103
        address                 10.151.193.71
        check_command           test!141.137.208.23!10.151.193.71
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-104
        alias                   ieatnetsimv5116-104
        address                 10.151.193.72
        check_command           test!141.137.208.23!10.151.193.72
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-105
        alias                   ieatnetsimv5116-105
        address                 10.151.193.73
        check_command           test!141.137.208.23!10.151.193.73
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-106
        alias                   ieatnetsimv5116-106
        address                 10.151.193.74
        check_command           test!141.137.208.23!10.151.193.74
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-107
        alias                   ieatnetsimv5116-107
        address                 10.151.193.75
        check_command           test!141.137.208.23!10.151.193.75
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-108
        alias                   ieatnetsimv5116-108
        address                 10.151.193.76
        check_command           test!141.137.208.23!10.151.193.76
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-109
        alias                   ieatnetsimv5116-109
        address                 10.151.193.77
        check_command           test!141.137.208.23!10.151.193.77
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-110
        alias                   ieatnetsimv5116-110
        address                 10.151.193.78
        check_command           test!141.137.208.23!10.151.193.78
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-111
        alias                   ieatnetsimv5116-111
        address                 10.151.192.139
        check_command           test!141.137.208.23!10.151.192.139
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-112
        alias                   ieatnetsimv5116-112
        address                 10.151.192.140
        check_command           test!141.137.208.23!10.151.192.140
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-113
        alias                   ieatnetsimv5116-113
        address                 10.151.192.141
        check_command           test!141.137.208.23!10.151.192.141
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-114
        alias                   ieatnetsimv5116-114
        address                 10.151.192.142
        check_command           test!141.137.208.23!10.151.192.142
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-115
        alias                   ieatnetsimv5116-115
        address                 10.151.192.143
        check_command           test!141.137.208.23!10.151.192.143
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-116
        alias                   ieatnetsimv5116-116
        address                 10.151.192.144
        check_command           test!141.137.208.23!10.151.192.144
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-117
        alias                   ieatnetsimv5116-117
        address                 10.151.192.145
        check_command           test!141.137.208.23!10.151.192.145
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-118
        alias                   ieatnetsimv5116-118
        address                 10.151.192.146
        check_command           test!141.137.208.23!10.151.192.146
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-119
        alias                   ieatnetsimv5116-119
        address                 10.151.192.147
        check_command           test!141.137.208.23!10.151.192.147
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv5116-120
        alias                   ieatnetsimv5116-120
        address                 10.151.192.148
        check_command           test!141.137.208.23!10.151.192.148
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-01
        alias                   ieatnetsimv017-01
        address                 10.151.88.162
	check_command		test!141.137.208.23!10.151.88.162
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-02
        alias                   ieatnetsimv017-02
        address                 10.151.88.163
	check_command		test!141.137.208.23!10.151.88.163
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-03
        alias                   ieatnetsimv017-03
        address                 10.151.88.164
	check_command		test!141.137.208.23!10.151.88.164
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-04
        alias                   ieatnetsimv017-04
        address                 10.151.88.165
	check_command		test!141.137.208.23!10.151.88.165
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-05
        alias                   ieatnetsimv017-05
        address                 10.151.88.166
	check_command		test!141.137.208.23!10.151.88.166
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-06
        alias                   ieatnetsimv017-06
        address                 10.151.88.167
	check_command		test!141.137.208.23!10.151.88.167
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-07
        alias                   ieatnetsimv017-07
        address                 10.151.88.168
	check_command		test!141.137.208.23!10.151.88.168
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-08
        alias                   ieatnetsimv017-08
        address                 10.151.88.169
	check_command		test!141.137.208.23!10.151.88.169
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-09
        alias                   ieatnetsimv017-09
        address                 10.151.88.170
	check_command		test!141.137.208.23!10.151.88.170
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-10
        alias                   ieatnetsimv017-10
        address                 10.151.88.171
	check_command		test!141.137.208.23!10.151.88.171
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-11
        alias                   ieatnetsimv017-11
        address                 10.151.88.216
	check_command		test!141.137.208.23!10.151.88.216
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-12
        alias                   ieatnetsimv017-12
        address                 10.151.88.217
	check_command		test!141.137.208.23!10.151.88.217
        contact_groups  623admins
        }

define host{
        use                     netsim-server
        host_name               ieatnetsimv017-13
        alias                   ieatnetsimv017-13
        address                 10.151.88.218
	check_command		test!141.137.208.23!10.151.88.218
        contact_groups  623admins
        }

#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-14
#        alias                   ieatnetsimv017-14
#        address                 10.151.88.219
#	check_command		test!141.137.208.23!10.151.88.219
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-15
#        alias                   ieatnetsimv017-15
#        address                 10.151.88.220
#	check_command		test!141.137.208.23!10.151.88.220
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-16
#        alias                   ieatnetsimv017-16
#        address                 10.151.88.221
#	check_command		test!141.137.208.23!10.151.88.221
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-17
#        alias                   ieatnetsimv017-17
#        address                 10.151.88.222
#	check_command		test!141.137.208.23!10.151.88.222
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-18
#        alias                   ieatnetsimv017-18
#        address                 10.151.88.223
#	check_command		test!141.137.208.23!10.151.88.223
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-19
#        alias                   ieatnetsimv017-19
#        address                 10.151.89.48
#	check_command		test!141.137.208.23!10.151.89.48
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-20
#        alias                   ieatnetsimv017-20
#        address                 10.151.89.68
#	check_command		test!141.137.208.23!10.151.89.68
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-21
#        alias                   ieatnetsimv017-21
#        address                 10.151.89.69
#	check_command		test!141.137.208.23!10.151.89.69
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-22
#        alias                   ieatnetsimv017-22
#        address                 10.151.89.70
#	check_command		test!141.137.208.23!10.151.89.70
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-23
#        alias                   ieatnetsimv017-23
#        address                 10.151.89.71
#	check_command		test!141.137.208.23!10.151.89.71
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-24
#        alias                   ieatnetsimv017-24
#        address                 10.151.89.226
#	check_command		test!141.137.208.23!10.151.89.226
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-25
#        alias                   ieatnetsimv017-25
#        address                 10.151.89.227
#	check_command		test!141.137.208.23!10.151.89.227
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-26
#        alias                   ieatnetsimv017-26
#        address                 10.151.89.228
#	check_command		test!141.137.208.23!10.151.89.228
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-27
#        alias                   ieatnetsimv017-27
#        address                 10.151.89.229
#	check_command		test!141.137.208.23!10.151.89.229
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-28
#        alias                   ieatnetsimv017-28
#        address                 10.151.89.230
#	check_command		test!141.137.208.23!10.151.89.230
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-29
#        alias                   ieatnetsimv017-29
#        address                 10.151.89.231
#	check_command		test!141.137.208.23!10.151.89.231
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-30
#        alias                   ieatnetsimv017-30
#        address                 10.151.89.232
#	check_command		test!141.137.208.23!10.151.89.232
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-31
#        alias                   ieatnetsimv017-31
#        address                 10.151.89.233
#	check_command		test!141.137.208.23!10.151.89.233
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-32
#        alias                   ieatnetsimv017-32
#        address                 10.151.89.234
#	check_command		test!141.137.208.23!10.151.89.234
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-33
#        alias                   ieatnetsimv017-33
#        address                 10.151.89.235
#	check_command		test!141.137.208.23!10.151.89.235
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-34
#        alias                   ieatnetsimv017-34
#        address                 10.151.89.236
#	check_command		test!141.137.208.23!10.151.89.236
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-35
#        alias                   ieatnetsimv017-35
#        address                 10.151.89.237
#	check_command		test!141.137.208.23!10.151.89.237
#        contact_groups  623admins
#        }
#
#define host{
#        use                     netsim-server
#        host_name               ieatnetsimv017-36
#        alias                   ieatnetsimv017-36
#        address                 10.151.89.238
#	check_command		test!141.137.208.23!10.151.89.238
#        contact_groups  623admins
#        }

define host{
        use                     linux-server
        host_name               ieatwlvm5116
        alias                   ieatwlvm5116
        address                 10.151.193.14
        check_command           test!141.137.208.23!10.151.193.14
        contact_groups  623admins
        }



###############################################################################
###############################################################################
##
## HOST GROUP DEFINITION
##
################################################################################
################################################################################
#
## Define an optional hostgroup for Linux machines
#
#define hostgroup{
#        hostgroup_name  Deployment_623 ; The name of the hostgroup
#        alias           623 ; Long name of the group
#        members         ieatlms3901,ieatrcxb2445,ieatrcxb3804,ieatrcxb2446,ieatrcxb3805,ieatrcxb3776,ieatrcxb3806,ieatrcxb3777,ieatrcxb3807,ieatrcxb3778,ieatrcxb3911,ieatrcxb3914,ieatrcxb4416,ieatrcxb3839,ieatrcxb6446,ieatrcxb3779,ieatrcxb3912,ieatrcxb3995,ieatrcxb3913,ieatnetsimv5116-01,ieatnetsimv5116-02,ieatnetsimv5116-03,ieatnetsimv5116-04,ieatnetsimv5116-05,ieatnetsimv5116-06,ieatnetsimv5116-07,ieatnetsimv5116-08,ieatnetsimv5116-09,ieatnetsimv5116-10,ieatnetsimv5116-11,ieatnetsimv5116-12,ieatnetsimv5116-13,ieatnetsimv5116-14,ieatnetsimv5116-15,ieatnetsimv5116-16,ieatnetsimv5116-17,ieatnetsimv5116-18,ieatnetsimv5116-19,ieatnetsimv5116-20,ieatnetsimv5116-21,ieatnetsimv5116-22,ieatnetsimv5116-23,ieatnetsimv5116-24,ieatnetsimv5116-25,ieatnetsimv5116-26,ieatnetsimv5116-27,ieatnetsimv5116-28,ieatnetsimv5116-29,ieatnetsimv5116-30,ieatnetsimv5116-31,ieatnetsimv5116-32,ieatnetsimv5116-33,ieatnetsimv5116-34,ieatnetsimv5116-35,ieatnetsimv5116-36,ieatnetsimv5116-37,ieatnetsimv5116-38,ieatnetsimv5116-39,ieatnetsimv5116-40,ieatnetsimv5116-41,ieatnetsimv5116-42,ieatnetsimv5116-43,ieatnetsimv5116-44,ieatnetsimv5116-45,ieatnetsimv5116-46,ieatnetsimv5116-47,ieatnetsimv5116-48,ieatnetsimv5116-49,ieatnetsimv5116-50,ieatnetsimv5116-51,ieatnetsimv5116-52,ieatnetsimv5116-53,ieatnetsimv5116-54,ieatnetsimv5116-55,ieatnetsimv5116-56,ieatnetsimv5116-57,ieatnetsimv5116-58,ieatnetsimv5116-59,ieatnetsimv5116-60,ieatnetsimv5116-61,ieatnetsimv5116-62,ieatnetsimv5116-63,ieatnetsimv5116-64,ieatnetsimv5116-65,ieatnetsimv5116-66,ieatnetsimv5116-67,ieatnetsimv5116-68,ieatnetsimv5116-69,ieatnetsimv5116-70,ieatnetsimv5116-71,ieatnetsimv5116-72,ieatnetsimv5116-73,ieatnetsimv5116-74,ieatnetsimv5116-75,ieatnetsimv5116-76,ieatnetsimv5116-77,ieatnetsimv5116-78,ieatnetsimv5116-79,ieatnetsimv5116-80,ieatnetsimv5116-81,ieatnetsimv5116-82,ieatnetsimv5116-83,ieatnetsimv5116-84,ieatnetsimv5116-85,ieatnetsimv5116-86,ieatnetsimv5116-87,ieatnetsimv5116-88,ieatnetsimv5116-89,ieatnetsimv5116-90,ieatnetsimv5116-91,ieatnetsimv5116-92,ieatnetsimv5116-93,ieatnetsimv5116-94,ieatnetsimv5116-95,ieatnetsimv5116-96,ieatnetsimv5116-97,ieatnetsimv5116-98,ieatnetsimv5116-99,ieatnetsimv5116-100,ieatnetsimv5116-101,ieatnetsimv5116-102,ieatnetsimv5116-103,ieatnetsimv5116-104,ieatnetsimv5116-105,ieatnetsimv5116-106,ieatnetsimv5116-107,ieatnetsimv5116-108,ieatnetsimv5116-109,ieatnetsimv5116-110,ieatnetsimv5116-111,ieatnetsimv5116-112,ieatnetsimv5116-113,ieatnetsimv5116-114,ieatnetsimv5116-115,ieatnetsimv5116-116,ieatnetsimv5116-117,ieatnetsimv5116-118,ieatnetsimv5116-119,ieatnetsimv5116-120,ieatnetsimv017-01,ieatnetsimv017-02,ieatnetsimv017-03,ieatnetsimv017-04,ieatnetsimv017-05,ieatnetsimv017-06,ieatnetsimv017-07,ieatnetsimv017-08,ieatnetsimv017-09,ieatnetsimv017-10,ieatnetsimv017-11,ieatnetsimv017-12,ieatnetsimv017-13,ieatnetsimv017-14,ieatnetsimv017-15,ieatnetsimv017-16,ieatnetsimv017-17,ieatnetsimv017-18,ieatnetsimv017-19,ieatnetsimv017-20,ieatnetsimv017-21,ieatnetsimv017-22,ieatnetsimv017-23,ieatnetsimv017-24,ieatnetsimv017-25,ieatnetsimv017-26,ieatnetsimv017-27,ieatnetsimv017-28,ieatnetsimv017-29,ieatnetsimv017-30,ieatnetsimv017-31,ieatnetsimv017-32,ieatnetsimv017-33,ieatnetsimv017-34,ieatnetsimv017-35,ieatnetsimv017-36,ieatwlvm5116     ; Comma separated list of hosts that belong to this group

define hostgroup{
        hostgroup_name  Deployment_623 ; The name of the hostgroup
        alias           623 ; Long name of the group
        members         ieatlms3901,ieatrcxb2445,ieatrcxb3804,ieatrcxb2446,ieatrcxb3805,ieatrcxb3776,ieatrcxb3806,ieatrcxb3777,ieatrcxb3807,ieatrcxb3778,ieatrcxb3911,ieatrcxb3914,ieatrcxb4416,ieatrcxb3839,ieatrcxb6446,ieatrcxb3779,ieatrcxb3912,ieatrcxb3995,ieatrcxb3913,ieatnetsimv5116-01,ieatnetsimv5116-02,ieatnetsimv5116-03,ieatnetsimv5116-04,ieatnetsimv5116-05,ieatnetsimv5116-06,ieatnetsimv5116-07,ieatnetsimv5116-08,ieatnetsimv5116-09,ieatnetsimv5116-10,ieatnetsimv5116-11,ieatnetsimv5116-12,ieatnetsimv5116-13,ieatnetsimv5116-14,ieatnetsimv5116-15,ieatnetsimv5116-16,ieatnetsimv5116-17,ieatnetsimv5116-18,ieatnetsimv5116-19,ieatnetsimv5116-20,ieatnetsimv5116-21,ieatnetsimv5116-22,ieatnetsimv5116-23,ieatnetsimv5116-24,ieatnetsimv5116-25,ieatnetsimv5116-26,ieatnetsimv5116-27,ieatnetsimv5116-28,ieatnetsimv5116-29,ieatnetsimv5116-30,ieatnetsimv5116-31,ieatnetsimv5116-32,ieatnetsimv5116-33,ieatnetsimv5116-34,ieatnetsimv5116-35,ieatnetsimv5116-36,ieatnetsimv5116-37,ieatnetsimv5116-38,ieatnetsimv5116-39,ieatnetsimv5116-40,ieatnetsimv5116-41,ieatnetsimv5116-42,ieatnetsimv5116-43,ieatnetsimv5116-44,ieatnetsimv5116-45,ieatnetsimv5116-46,ieatnetsimv5116-47,ieatnetsimv5116-48,ieatnetsimv5116-49,ieatnetsimv5116-50,ieatnetsimv5116-51,ieatnetsimv5116-52,ieatnetsimv5116-53,ieatnetsimv5116-54,ieatnetsimv5116-55,ieatnetsimv5116-56,ieatnetsimv5116-57,ieatnetsimv5116-58,ieatnetsimv5116-59,ieatnetsimv5116-60,ieatnetsimv5116-61,ieatnetsimv5116-62,ieatnetsimv5116-63,ieatnetsimv5116-64,ieatnetsimv5116-65,ieatnetsimv5116-66,ieatnetsimv5116-67,ieatnetsimv5116-68,ieatnetsimv5116-69,ieatnetsimv5116-70,ieatnetsimv5116-71,ieatnetsimv5116-72,ieatnetsimv5116-73,ieatnetsimv5116-74,ieatnetsimv5116-75,ieatnetsimv5116-76,ieatnetsimv5116-77,ieatnetsimv5116-78,ieatnetsimv5116-79,ieatnetsimv5116-80,ieatnetsimv5116-81,ieatnetsimv5116-82,ieatnetsimv5116-83,ieatnetsimv5116-84,ieatnetsimv5116-85,ieatnetsimv5116-86,ieatnetsimv5116-87,ieatnetsimv5116-88,ieatnetsimv5116-89,ieatnetsimv5116-90,ieatnetsimv5116-91,ieatnetsimv5116-92,ieatnetsimv5116-93,ieatnetsimv5116-94,ieatnetsimv5116-95,ieatnetsimv5116-96,ieatnetsimv5116-97,ieatnetsimv5116-98,ieatnetsimv5116-99,ieatnetsimv5116-100,ieatnetsimv5116-101,ieatnetsimv5116-102,ieatnetsimv5116-103,ieatnetsimv5116-104,ieatnetsimv5116-105,ieatnetsimv5116-106,ieatnetsimv5116-107,ieatnetsimv5116-108,ieatnetsimv5116-109,ieatnetsimv5116-110,ieatnetsimv5116-111,ieatnetsimv5116-112,ieatnetsimv5116-113,ieatnetsimv5116-114,ieatnetsimv5116-115,ieatnetsimv5116-116,ieatnetsimv5116-117,ieatnetsimv5116-118,ieatnetsimv5116-119,ieatnetsimv5116-120,ieatnetsimv017-01,ieatnetsimv017-02,ieatnetsimv017-03,ieatnetsimv017-04,ieatnetsimv017-05,ieatnetsimv017-06,ieatnetsimv017-07,ieatnetsimv017-08,ieatnetsimv017-09,ieatnetsimv017-10,ieatnetsimv017-11,ieatnetsimv017-12,ieatnetsimv017-13,ieatwlvm5116     ; Comma separated list of hosts that belong to this group

}

#
#
#
#
################################################################################
################################################################################
##
## SERVICE DEFINITIONS
##
################################################################################
################################################################################
#

# RPM CHECK DIFF
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check rpm diff
        check_command           diff_rpm_iso_installed!141.137.208.23
        check_interval          60
        contact_groups          623admins
        }

#PM CHECKS RADIO/CORE

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical ERBS
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!ERBS!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical RadioNode
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!RadioNode!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical RBS
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!RBS!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical MGW
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!MGW!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical DSC
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!DSC!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical SGSN-MME
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!SGSN-MME!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

#PM CHECKS RADIO/CORE - 2

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical EPG
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!EPG!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical ESC
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!ESC!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical FRONTHAUL-6080
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!FRONTHAUL-6080!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical MSC-BC-BSP
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!MSC-BC-BSP!ieatENM5623-10.athtem.eei.ericsson.se!6
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical MSC-BC-IS
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!MSC-BC-IS!ieatENM5623-10.athtem.eei.ericsson.se!6
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical MSC-DB-BSP
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!MSC-DB-BSP!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical MTAS
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!MTAS!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical Router6274
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!Router6274!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical Router6672
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!Router6672!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical SBG-IS
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!SBG-IS!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical RNC
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!RNC!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical MINI-LINK-669x
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!MINI-LINK-669x!ieatENM5623-10.athtem.eei.ericsson.se!4
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical MINI-LINK-6352
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!MINI-LINK-6352!ieatENM5623-10.athtem.eei.ericsson.se!1
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical BSC
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!BSC!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm collection statistical CISCO-ASR900
        check_command           check_pm_collection_stat!141.137.208.23!10.151.193.14!CISCO-ASR900!ieatENM5623-10.athtem.eei.ericsson.se!1
        check_interval      60
        contact_groups  623admins
        }

#FM Checks hb failures

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures BSC
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!BSC 
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures CISCO-ASR900
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!CISCO-ASR900 
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures DSC
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!DSC 
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures EPG
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!EPG
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures ERBS
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!ERBS
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures ESC
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!ESC
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures FRONTHAUL-6080
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!FRONTHAUL-6080
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures MGW
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!MGW
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures MINI-LINK-6352
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!MINI-LINK-6352
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures MINI-LINK-669x
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!MINI-LINK-669x
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures MSC-BC-BSP
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!MSC-BC-BSP
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures MSC-BC-IS
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!MSC-BC-IS
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures MSC-DB-BSP
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!MSC-DB-BSP
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures MTAS
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!MTAS
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures RadioNode
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!RadioNode
        check_interval      60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures RBS
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!RBS
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures RNC
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!RNC
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures Router6672
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!Router6672
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures Router6274
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!Router6274
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures SBG-IS
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!SBG-IS
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm hb failures SGSN-MME
        check_command           check_fm_hb_failures!141.137.208.23!10.151.193.14!SGSN-MME
    check_interval      60
    contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check snapshots
        check_command           check_snapshots!141.137.208.23
	check_interval		1440
        contact_groups  623admins
        }

#define service{
#        use                     generic-service
#        host_name               ieatlms3901
#        service_description     check synchronized snmp
#        check_command           check_synchronized!141.137.208.23 "MINI-LINK-6352 MINI-LINK-669x" SNMP
#	check_interval		30
#        contact_groups  623admins
#        }

#define service{
#        use                     generic-service
#        host_name               ieatlms3901
#        service_description     check synchronized cpp
#        check_command           check_synchronized!141.137.208.23 "RBS ERBS MTAS MGW" CPP
#        check_interval          30
#        contact_groups  623admins
#        }

#define service{
#        use                     generic-service
#        host_name               ieatlms3901
#        service_description     check synchronized comecim
#        check_command           check_synchronized!141.137.208.23 "SGSN-MME RadioNode RNC DSC RNC" COMECIM
#        check_interval          30
#        contact_groups  623admins
#        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized BSC
        check_command           check_synchronized!141.137.208.23!10.151.193.14!BSC
        check_interval          30
        contact_groups          623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized DSC
        check_command           check_synchronized!141.137.208.23!10.151.193.14!DSC
        check_interval          30
        contact_groups          623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized CISCO-ASR900
        check_command           check_synchronized!141.137.208.23!10.151.193.14!CISCO-ASR900
        check_interval          30
        contact_groups          623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized EPG
        check_command           check_synchronized!141.137.208.23!10.151.193.14!EPG
        check_interval          30
        contact_groups          623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized ERBS
        check_command           check_synchronized!141.137.208.23!10.151.193.14!ERBS
        check_interval          30
        contact_groups          623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized ESC
        check_command           check_synchronized!141.137.208.23!10.151.193.14!ESC
        check_interval          30
        contact_groups          623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized FRONTHAUL-6080
        check_command           check_synchronized!141.137.208.23!10.151.193.14!FRONTHAUL-6080
        check_interval          30
        contact_groups          623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized MGW
        check_command           check_synchronized!141.137.208.23!10.151.193.14!MGW
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized MINI-LINK-6352
        check_command           check_synchronized!141.137.208.23!10.151.193.14!MINI-LINK-6352
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized MINI-LINK-669x
        check_command           check_synchronized!141.137.208.23!10.151.193.14!MINI-LINK-669x
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized MSC-BC-BSP
        check_command           check_synchronized!141.137.208.23!10.151.193.14!MSC-BC-BSP
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized MSC-BC-IS
        check_command           check_synchronized!141.137.208.23!10.151.193.14!MSC-BC-IS
   check_interval      30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized MSC-DB-BSP
        check_command           check_synchronized!141.137.208.23!10.151.193.14!MSC-DB-BSP
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized MTAS
        check_command           check_synchronized!141.137.208.23!10.151.193.14!MTAS
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized RBS
        check_command           check_synchronized!141.137.208.23!10.151.193.14!RBS
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized RadioNode
        check_command           check_synchronized!141.137.208.23!10.151.193.14!RadioNode
   check_interval      30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized RNC
        check_command           check_synchronized!141.137.208.23!10.151.193.14!RNC
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized Router6274
        check_command           check_synchronized!141.137.208.23!10.151.193.14!Router6274
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized Router6672
        check_command           check_synchronized!141.137.208.23!10.151.193.14!Router6672
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized SBG-IS
        check_command           check_synchronized!141.137.208.23!10.151.193.14!SBG-IS
        check_interval          30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check synchronized SGSN-MME
        check_command           check_synchronized!141.137.208.23!10.151.193.14!SGSN-MME
   check_interval      30
        contact_groups  623admins
        servicegroups           check-synchronized-group
        }


define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check hw resources hc
        check_command           check_enm_hc!141.137.208.23 hw_resources_healthcheck
        check_interval          60
        contact_groups          623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check mdt hc
        check_command           check_enm_hc!141.137.208.23 mdt_healthcheck
        check_interval          60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check nas hc
        check_command           check_enm_hc!141.137.208.23 nas_healthcheck
        check_interval          60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check node fs hc
        check_command           check_enm_hc!141.137.208.23 node_fs_healthcheck
        check_interval          30
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check storagepool hc
        check_command           check_enm_hc!141.137.208.23 storagepool_healthcheck
        check_interval          60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check system service hc
        check_command           check_enm_hc!141.137.208.23 system_service_healthcheck
        check_interval          30
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check vcs cluster hc
        check_command           check_enm_hc!141.137.208.23 vcs_cluster_healthcheck
        check_interval          30
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check vcs llt heartbeat hc
        check_command           check_enm_hc!141.137.208.23 vcs_llt_heartbeat_healthcheck
        check_interval          30
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check vcs service group hc
        check_command           check_enm_hc!141.137.208.23 vcs_service_group_healthcheck
        check_interval          30
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check san alert healthcheck 
        check_command           check_enm_hc!141.137.208.23 san_alert_healthcheck 
        check_interval          60
        contact_groups  623admins
        }

#define service{
#        use                     generic-service
#        host_name               ieatlms3901
#        service_description     check cm supervision nodes
#        check_command           check_cmsupervision_nodes!141.137.208.23
#        check_interval          15
#        contact_groups  623admins
#        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes BSC
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!BSC
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes DSC
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!DSC
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes ERBS
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!ERBS
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes MGW
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!MGW
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes MINI-LINK-6352
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!MINI-LINK-6352
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes MINI-LINK-669x
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!MINI-LINK-669x
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes MSC-BC-IS
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-BC-IS
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes MSC-DB-BSP
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-DB-BSP
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes MSC-BC-BSP
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-BC-BSP
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes MTAS
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!MTAS
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes RadioNode
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!RadioNode
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes RBS
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!RBS
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes RNC
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!RNC
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes Router6672
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!Router6672
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes CISCO-ASR900
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!CISCO-ASR900
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes EPG
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!EPG
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes ESC
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!ESC
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes FRONTHAUL-6080
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!FRONTHAUL-6080
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes Router6274
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!Router6274
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes SBG-IS
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!SBG-IS
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check cm supervision nodes SGSN-MME
        check_command           check_cmsupervision_nodes!141.137.208.23!10.151.193.14!SGSN-MME
        check_interval          15
        contact_groups  623admins
        servicegroups           cm-supervision-nodes-group
        }

#define service{
#       use                     generic-service
#       host_name               ieatlms3901
#       service_description     check fm supervision nodes
#       check_command           check_fmsupervision_nodes!141.137.208.23
#       check_interval          15
#       contact_groups  623admins
#       }

#FM supervision Checks 

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes BSC
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!BSC
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes DSC
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!DSC
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes ERBS
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!ERBS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes MGW
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!MGW
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes MINI-LINK-6352 
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!MINI-LINK-6352
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes MINI-LINK-669x 
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!MINI-LINK-669x
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes MSC-BC-IS
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-BC-IS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes MSC-DB-BSP
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-DB-BSP
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes MSC-BC-BSP
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-BC-BSP
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes MTAS
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!MTAS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes RadioNode
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!RadioNode
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes RBS
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!RBS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes RNC
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!RNC
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes Router6672
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!Router6672
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes CISCO-ASR900
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!CISCO-ASR900
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes EPG
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!EPG
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes ESC
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!ESC
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes FRONTHAUL-6080
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!FRONTHAUL-6080
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes Router6274
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!Router6274
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes SBG-IS
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!SBG-IS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check fm supervision nodes SGSN-MME
        check_command           check_fmsupervision_nodes!141.137.208.23!10.151.193.14!SGSN-MME
        check_interval          15
        contact_groups  623admins
        }

#define service{
#        use                     generic-service
#        host_name               ieatlms3901
#        service_description     check pm supervision nodes
#        check_command           check_pmsupervision_nodes!141.137.208.23
#        check_interval          15
#        contact_groups  623admins
#        }

#PM supervision Checks 

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes BSC
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!BSC
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes DSC
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!DSC
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes ERBS
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!ERBS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes MGW
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!MGW
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes MINI-LINK-6352 
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!MINI-LINK-6352
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes MINI-LINK-669x 
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!MINI-LINK-669x
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes MSC-BC-IS
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-BC-IS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes MSC-DB-BSP
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-DB-BSP
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes MSC-BC-BSP
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!MSC-BC-BSP
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes MTAS
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!MTAS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes RadioNode
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!RadioNode
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes RBS
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!RBS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes RNC
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!RNC
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes Router6672
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!Router6672
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes CISCO-ASR900
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!CISCO-ASR900
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes EPG
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!EPG
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes ESC
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!ESC
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes FRONTHAUL-6080
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!FRONTHAUL-6080
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes Router6274
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!Router6274
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes SBG-IS
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!SBG-IS
        check_interval          15
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check pm supervision nodes SGSN-MME
        check_command           check_pmsupervision_nodes!141.137.208.23!10.151.193.14!SGSN-MME
        check_interval          15
        contact_groups          623admins
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service 
        host_name               ieatlms3901
        service_description     copy nodes workload
        check_command           copy_nodes_workload!141.137.208.23 ieatwlvm5116
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check list nodes
        check_command           check_list_nodes!141.137.208.23!"ieatnetsimv5116 ieatnetsimv017" 
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }


#FRONTHAUL-6080 - Fronthaul-6080
#CISCO-ASR900 - ASR900 


# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes BSC 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!BSC!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes RBS 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!RBS!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes CISCO-ASR900 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!ASR900!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes DSC 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!DSC!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes EPG 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!EPG!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes ERBS 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!ERBS!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes ESC 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!ESC!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes FRONTHAUL-6080 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!Fronthaul-6080!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes MGW 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!MGW!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes MINI-LINK-6352 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!MINI-LINK-6352!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes MINI-LINK-669x 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!MINI-LINK-669x!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes MSC-BC-BSP 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!MSC-BC-BSP!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes MSC-BC-IS 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!MSC-BC-IS!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes MSC-DB-BSP 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!MSC-DB-BSP!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes MTAS 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!MTAS!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes RNC 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!RNC!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes RadioNode 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!RadioNode!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes Router6274 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!Router6274!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes Router6672 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!Router6672!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes SBG-IS 
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!SBG-IS!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# notification-service - view config mail in template.cfg
define service{
        use                     notification-service
        host_name               ieatlms3901
        service_description     check number nodes SGSN-MME
        check_command           check_number_nodes!141.137.208.23!10.151.193.14!SGSN-MME!"ieatnetsimv5116 ieatnetsimv017"
        check_interval          60
        contact_groups          623admins
        servicegroups           number-node-group
        }

# ##############################################################################################################

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check node fs
        check_command           check_node_fs!141.137.208.23
        check_interval          30
        contact_groups  623admins
        }


define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check vcs sg
        check_command           check_vcs_sg!141.137.208.23
        check_interval          30
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatlms3901
        service_description     check unsync nodes
        check_command           check_unsync_nodes!141.137.208.23
        check_interval          30
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-01
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.175
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-02
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.176
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-03
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.177
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-04
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.178
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-05
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.179
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-06
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.180
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-07
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.181
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-08
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.182
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-09
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.183
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-10
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.184
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-11
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.185
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-12
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.186
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-13
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.187
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-14
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.188
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-15
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.189
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-16
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.190
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-17
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.191
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-18
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.192
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-19
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.193
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-20
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.194
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-21
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.195
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-22
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.196
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-23
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.197
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-24
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.198
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-25
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.199
        check_interval          60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-26
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.200
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-27
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.201
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-28
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.202
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-29
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.203
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-30
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.204
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-31
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.205
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-32
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.206
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-33
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.207
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-34
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.208
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-35
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.209
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-36
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.210
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-37
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.211
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-38
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.212
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-39
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.213
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-40
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.214
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-41
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.215
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-42
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.216
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-43
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.217
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-44
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.218
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-45
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.219
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-46
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.220
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-47
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.221
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-48
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.222
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-49
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.223
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-50
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.224
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-51
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.225
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-52
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.226
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-53
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.227
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-54
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.228
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-55
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.229
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-56
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.230
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-57
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.231
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-58
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.232
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-59
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.233
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-60
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.234
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-61
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.235
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-62
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.236
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-63
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.237
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-64
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.238
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-65
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.239
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-66
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.240
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-67
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.241
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-68
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.242
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-69
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.243
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-70
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.244
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-71
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.245
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-72
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.246
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-73
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.247
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-74
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.248
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-75
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.249
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-76
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.250
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-77
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.251
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-78
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.252
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-79
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.253
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-80
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.254
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-81
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.255
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-82
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.0
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-83
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.1
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-84
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.2
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-85
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.3
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-86
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.4
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-87
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.5
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-88
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.6
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-89
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.7
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-90
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.8
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-91
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.9
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-92
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.10
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-93
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.11
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-94
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.12
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-95
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.63
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-96
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.64
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-97
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.65
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-98
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.66
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-99
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.67
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-100
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.68
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-101
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.69
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-102
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.70
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-103
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.71
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-104
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.72
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-105
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.73
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-106
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.74
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-107
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.75
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-108
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.76
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-109
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.77
	check_interval		
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-110
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.193.78
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-111
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.139
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-112
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.140
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-113
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.141
	check_interval		
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-114
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.142
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-115
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.143
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-116
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.144
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-117
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.145
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-118
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.146
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-119
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.147
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-120
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.192.148
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-01
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.162
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-02
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.163
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-03
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.164
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-04
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.165
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-05
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.166
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-06
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.167
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-07
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.168
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-08
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.169
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-09
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.170
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-10
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.171
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-11
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.216
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-12
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.217
	check_interval		60
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-13
        service_description     check netsim cpu
        check_command           check_netsim_cpu!141.137.208.23!10.151.88.218
	check_interval		60
        contact_groups  623admins
        }

#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-14
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.88.219
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-15
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.88.220
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-16
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.88.221
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-17
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.88.222
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-18
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.88.223
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-19
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.48
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-20
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.68
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-21
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.69
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-22
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.70
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-23
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.71
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-24
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.226
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-25
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.227
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-26
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.228
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-27
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.229
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-28
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.230
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-29
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.231
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-30
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.232
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-31
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.233
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-32
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.234
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-33
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.235
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-34
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.236
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-35
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.237
#	check_interval		60
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-36
#        service_description     check netsim cpu
#        check_command           check_netsim_cpu!141.137.208.23!10.151.89.238
#	check_interval		60
#        contact_groups  623admins
#        }

define service{
	use			generic-service
	host_name		ieatnetsimv5116-01
	service_description	check netsim nodes
	check_command		check_netsim_nodes!141.137.208.23!10.151.192.175
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.175
        contact_groups  623admins
	}

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-02
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.176
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.176
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-03
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.177
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.177
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-04
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.178
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.178
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-05
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.179
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.179
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-06
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.180
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.180
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-07
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.181
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.181
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-08
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.182
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.182
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-09
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.183
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.183
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-10
        service_description     check netsim nodes
       check_command           check_netsim_nodes!141.137.208.23!10.151.192.184
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.184
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-11
       service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.185
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.185
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-12
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.186
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.186
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-13
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.187
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.187
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-14
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.188
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.188
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-15
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.189
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.189
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-16
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.190
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.190
        contact_groups  623admins
        }

define service{
	use			generic-service
	host_name		ieatnetsimv5116-17
	service_description	check netsim nodes
	check_command		check_netsim_nodes!141.137.208.23!10.151.192.191
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.191
        contact_groups  623admins
	}

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-18
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.192
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.192
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-19
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.193
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.193
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-20
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.194
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.194
        contact_groups  623admins
      }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-21
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.195
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.195
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-22
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.196
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.196
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-23
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.197
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.197
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-24
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.198
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.198
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-25
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.199
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.199
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-26
        service_description     check netsim nodes
       check_command           check_netsim_nodes!141.137.208.23!10.151.192.200
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.200
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-27
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.201
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.201
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-28
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.202
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.202
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-29
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.203
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.203
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-30
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.204
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.204
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-31
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.205
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.205
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-32
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.206
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.206
        contact_groups  623admins
        }

define service{
	use			generic-service
	host_name		ieatnetsimv5116-33
	service_description	check netsim nodes
	check_command		check_netsim_nodes!141.137.208.23!10.151.192.207
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.207
        contact_groups  623admins
	}

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-34
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.208
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.208
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-35
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.209
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.209
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-36
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.210
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.210
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-37
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.211
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.211
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-38
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.212
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.212
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-39
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.213
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.213
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-40
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.214
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.214
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-41
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.215
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.215
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-42
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.216
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.216
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-43
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.217
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.217
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-44
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.218
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.218
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-45
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.219
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-46
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.220
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.220
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-47
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.221
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.221
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-48
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.222
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.222
        contact_groups  623admins
        }

define service{
	use			generic-service
	host_name		ieatnetsimv5116-49
	service_description	check netsim nodes
	check_command		check_netsim_nodes!141.137.208.23!10.151.192.223
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.223
        contact_groups  623admins
	}

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-50
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.224
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.224
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-51
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.225
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.225
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-52
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.226
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.226
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-53
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.227
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.227
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-54
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.228
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.228
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-55
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.229
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.229
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-56
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.230
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.230
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-57
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.231
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.231
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-58
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.232
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.232
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-59
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.233
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.233
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-60
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.234
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.234
        contact_groups  623admins
        }

define service{
       use                     generic-service
        host_name               ieatnetsimv5116-61
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.235
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.235
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-62
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.236
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.236
        contact_groups  623admins
       }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-63
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.237
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.237
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-64
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.238
	check_interval		30
	event_handler           start_netsim_nodes!141.137.208.23!10.151.192.238
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-65
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.239
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.239
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-66
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.240
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.240
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-67
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.241
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.241
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-68
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.242
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.242
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-69
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.243
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.243
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-70
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.244
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.244
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-71
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.245
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.245
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-72
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.246
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.246
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-73
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.247
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.247
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-74
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.248
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.248
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-75
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.249
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.249
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-76
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.250
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.250
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-77
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.251
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.251
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-78
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.252
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.252
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-79
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.253
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.253
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-80
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.254
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.254
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-81
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.255
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.255
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-82
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.0
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.0
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-83
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.1
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.1
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-84
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.2
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.2
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-85
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.3
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.3
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-86
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.4
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.4
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-87
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.5
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.5
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-88
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.6
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.6
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-89
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.7
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.7
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-90
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.8
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.8
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-91
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.9
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.9
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-92
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.10
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.10
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-93
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.11
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.11
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-94
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.12
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.12
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-95
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.63
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.63
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-96
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.64
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.64
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-97
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.65
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.65
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-98
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.66
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.66
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-99
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.67
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.67
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-100
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.68
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.68
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-101
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.69
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.69
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-102
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.70
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.70
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-103
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.71
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.71
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-104
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.72
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.72
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-105
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.73
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.73
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-106
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.74
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.74
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-107
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.75
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.75
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-108
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.76
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.76
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-109
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.77
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.77
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-110
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.193.78
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.193.78
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-111
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.139
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.139
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-112
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.140
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.140
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-113
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.141
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.141
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-114
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.142
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.142
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-115
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.143
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.143
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-116
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.144
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.144
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-117
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.145
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.145
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-118
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.146
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.146
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-119
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.147
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.147
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-120
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.192.148
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.192.148
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-01
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.162
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.162
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-02
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.163
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.163
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-03
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.164
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.164
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-04
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.165
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.165
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-05
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.166
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.166
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-06
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.167
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.167
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-07
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.168
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.168
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-08
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.169
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.169
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-09
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.170
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.170
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-10
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.171
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.171
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-11
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.216
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.216
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-12
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.217
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.217
        contact_groups  623admins

        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-13
        service_description     check netsim nodes
        check_command           check_netsim_nodes!141.137.208.23!10.151.88.218
	check_interval		30
        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.218
        contact_groups  623admins

        }

#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-14
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.88.219
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.219
#        contact_groups  623admins
#
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-15
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.88.220
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.220
#        contact_groups  623admins
#
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-16
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.88.221
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.221
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-17
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.88.222
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.222
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-18
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.88.223
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.88.223
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-19
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.48
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.48
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-20
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.68
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.68
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-21
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.69
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-22
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.70
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.70
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-23
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.71
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.71
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-24
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.226
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.226
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-25
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.227
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.227
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-26
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.228
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.228
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-27
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.229
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.229
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-28
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.230
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.230
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-29
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.231
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.231
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-30
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.232
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-31
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.233
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.233
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-32
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.234
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.234
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-33
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.235
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.235
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-34
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.236
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.236
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-35
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.237
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.237
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-36
#        service_description     check netsim nodes
#        check_command           check_netsim_nodes!141.137.208.23!10.151.89.238
#	check_interval		30
#        event_handler           start_netsim_nodes!141.137.208.23!10.151.89.238
#        contact_groups  623admins
#        }

define service{
	use			generic-service
	host_name		ieatnetsimv5116-01
	service_description	check netsim disk
	check_command		check_netsim_disk!141.137.208.23!10.151.192.175
	check_interval		60
	event_handler		delete_netsim_backupfiles!141.137.208.23!10.151.192.175
        contact_groups  623admins
	}

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-02
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.176
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.176
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-03
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.177
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.177
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-04
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.178
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.178
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-05
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.179
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.179
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-06
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.180
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.180
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-07
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.181
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.181
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-08
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.182
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.182
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-09
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.183
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.183
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-10
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.184
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.184
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-11
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.185
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.185
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-12
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.186
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.186
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-13
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.187
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.187
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-14
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.188
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.188
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-15
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.189
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.189
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-16
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.190
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.190
       contact_groups  623admins
        }


define service{
	use			generic-service
	host_name		ieatnetsimv5116-17
	service_description	check netsim disk
	check_command		check_netsim_disk!141.137.208.23!10.151.192.191
	check_interval		60
	event_handler		delete_netsim_backupfiles!141.137.208.23!10.151.192.191
        contact_groups  623admins
	}


define service{
        use                     generic-service
        host_name               ieatnetsimv5116-18
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.192
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.192
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-19
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.193
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.193
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-20
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.194
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.194
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-21
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.195
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.195
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-22
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.196
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.196
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-23
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.197
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.197
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-24
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.198
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.198
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-25
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.199
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.199
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-26
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.200
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.200
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-27
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.201
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.201
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-28
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.202
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.202
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-29
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.203
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.203
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-30
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.204
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.204
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-31
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.205
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.205
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-32
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.206
	check_interval		60
      event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.206
      contact_groups  623admins
        }

define service{
	use			generic-service
	host_name		ieatnetsimv5116-33
	service_description	check netsim disk
	check_command		check_netsim_disk!141.137.208.23!10.151.192.207
	check_interval		60
	event_handler		delete_netsim_backupfiles!141.137.208.23!10.151.192.207
        contact_groups  623admins
	}

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-34
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.208
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.208
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-35
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.209
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.209
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-36
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.210
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.210
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-37
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.211
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.211
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-38
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.212
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.212
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-39
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.213
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.213
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-40
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.214
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.214
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-41
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.215
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.215
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-42
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.216
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.216
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-43
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.217
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.217
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-44
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.218
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.218
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-45
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.219
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.219
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-46
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.220
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.220
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-47
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.221
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.221
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-48
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.222
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.222
       contact_groups  623admins
        }


define service{
	use			generic-service
	host_name		ieatnetsimv5116-49
	service_description	check netsim disk
	check_command		check_netsim_disk!141.137.208.23!10.151.192.223
	check_interval		60
	event_handler		delete_netsim_backupfiles!141.137.208.23!10.151.192.223
        contact_groups  623admins
	}

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-50
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.224
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.224
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-51
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.225
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.225
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-52
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.226
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.226
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-53
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.227
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.227
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-54
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.228
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.228
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-55
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.229
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.229
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-56
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.230
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.230
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-57
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.231
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.231
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-58
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.232
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.232
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-59
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.233
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.233
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-60
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.234
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.234
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-61
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.235
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.235
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-62
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.236
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.236
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-63
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.237
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.237
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-64
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.238
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.238
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-65
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.239
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.239
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-66
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.240
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.240
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-67
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.241
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.241
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-68
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.242
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.242
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-69
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.243
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.243
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-70
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.244
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.244
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-71
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.245
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.245
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-72
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.246
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.246
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-73
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.247
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.247
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-74
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.248
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.248
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-75
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.249
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.249
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-76
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.250
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.250
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-77
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.251
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.251
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-78
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.252
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.252
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-79
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.253
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.253
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-80
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.254
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.254
       contact_groups  623admins
        }

define service{
       use                     generic-service
        host_name               ieatnetsimv5116-81
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.255
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.255
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-82
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.0
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.0
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-83
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.1
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.1
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-84
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.2
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.2
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-85
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.3
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.3
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-86
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.4
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.4
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-87
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.5
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.5
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-88
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.6
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.6
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-89
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.7
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.7
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-90
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.8
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.8
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-91
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.9
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.9
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-92
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.10
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.10
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-93
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.11
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.11
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-94
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.12
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.12
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-95
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.63
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.63
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-96
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.64
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.64
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-97
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.65
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.65
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-98
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.66
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.66
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-99
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.67
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.67
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-100
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.68
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.68
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-101
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.69
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.69
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-102
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.70
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.70
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-103
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.71
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.71
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-104
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.72
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.72
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-105
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.73
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.73
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-106
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.74
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.74
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-107
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.75
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.75
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-108
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.76
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.76
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-109
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.77
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.77
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-110
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.193.78
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.193.78
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-111
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.139
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.139
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-112
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.140
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.140
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-113
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.141
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.141
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-114
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.142
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.142
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-115
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.143
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.143
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-116
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.144
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.144
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-117
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.145
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.145
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-118
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.146
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.146
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-119
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.147
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.147
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv5116-120
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.192.148
	check_interval		60
       event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.192.148
       contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-01
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.162
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.162
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-02
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.163
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.163
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-03
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.164
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.164
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-04
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.165
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.165
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-05
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.166
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.166
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-06
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.167
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.167
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-07
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.168
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.168
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-08
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.169
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.169
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-09
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.170
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.170
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-10
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.171
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.171
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-11
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.216
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.216
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-12
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.217
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.217
        contact_groups  623admins
        }

define service{
        use                     generic-service
        host_name               ieatnetsimv017-13
        service_description     check netsim disk
        check_command           check_netsim_disk!141.137.208.23!10.151.88.218
	check_interval		60
        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.218
        contact_groups  623admins
        }

#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-14
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.88.219
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.219
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-15
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.88.220
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.220
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-16
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.88.221
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.221
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-17
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.88.222
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.222
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-18
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.88.223
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.88.223
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-19
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.48
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.48
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-20
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.68
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.68
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-21
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.69
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.69
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-22
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.70
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.70
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-23
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.71
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.71
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-24
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.226
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.226
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-25
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.227
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.227
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-26
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.228
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.228
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-27
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.229
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.229
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-28
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.230
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.230
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-29
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.231
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.231
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-30
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.232
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.232
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-31
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.233
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.233
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-32
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.234
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.234
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-33
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.235
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.235
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-34
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.236
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.236
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-35
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.237
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.237
#        contact_groups  623admins
#        }
#
#define service{
#        use                     generic-service
#        host_name               ieatnetsimv017-36
#        service_description     check netsim disk
#        check_command           check_netsim_disk!141.137.208.23!10.151.89.238
#	check_interval		60
#        event_handler           delete_netsim_backupfiles!141.137.208.23!10.151.89.238
#        contact_groups  623admins
#        }
#define service{
#        use                     generic-service
#        host_name               ieatwlvm5116
#        service_description     check workload profiles
#        check_command           check_workloads!141.137.208.23!10.151.193.14
#        contact_groups  623admins
#        }

define service{
        use                     generic-service
        host_name               ieatwlvm5116
        service_description     check workload profiles started
        check_command           check_workloads_started!141.137.208.23!10.151.193.14!"AMOS_01 AMOS_02 AMOS_03 AMOS_04 AMOS_05 AMOS_08 AMOS_09 APT_01 AP_01 AP_11 AP_12 AP_13 AP_14 AP_15 AP_16 AP_SETUP CELLMGT_01 CELLMGT_02 CELLMGT_07 CELLMGT_08 CELLMGT_09 CELLMGT_10 CELLMGT_11 CELLMGT_12 CELLMGT_13 CELLMGT_14 CELLMGT_15 CLI_MON_01 CLI_MON_02 CLI_MON_03 CMEVENTS_NBI_01 CMEXPORT_01 CMEXPORT_02 CMEXPORT_03 CMEXPORT_05 CMEXPORT_06 CMEXPORT_07 CMEXPORT_08 CMEXPORT_11 CMEXPORT_12 CMEXPORT_13 CMEXPORT_14 CMEXPORT_16 CMEXPORT_17 CMEXPORT_18 CMEXPORT_19 CMEXPORT_20 CMEXPORT_21 CMEXPORT_22 CMEXPORT_23 CMIMPORT_01 CMIMPORT_02 CMIMPORT_03 CMIMPORT_04 CMIMPORT_05 CMIMPORT_08 CMIMPORT_10 CMIMPORT_11 CMIMPORT_12 CMIMPORT_13 CMIMPORT_14 CMIMPORT_15 CMIMPORT_16 CMIMPORT_17 CMIMPORT_18 CMIMPORT_19 CMIMPORT_20 CMIMPORT_21 CMIMPORT_22 CMSYNC_02 CMSYNC_04 CMSYNC_06 CMSYNC_08 CMSYNC_09 CMSYNC_10 CMSYNC_11 CMSYNC_15 CMSYNC_19 CMSYNC_20 CMSYNC_25 CMSYNC_26 CMSYNC_28 CMSYNC_29 CMSYNC_30 CMSYNC_32 CMSYNC_35 CMSYNC_37 CMSYNC_38 CMSYNC_SETUP CONFIGURATION_TEMPLATE_01 CONFIGURATION_TEMPLATE_02 DOC_01 EBSL_01 EBSL_05 EBSL_06 EBSM_04 EBSN_01 EBSN_02 ENMCLI_01 ENMCLI_02 ENMCLI_03 ENMCLI_05 ENMCLI_06 ENMCLI_07 ESM_01 FMX_01 FMX_05 FM_01 FM_02 FM_03 FM_0506 FM_08 FM_09 FM_10 FM_11 FM_12 FM_14 FM_15 FM_17 FM_20 FM_21 FM_25 FM_26 FM_27 FM_30 HA_01 LAUNCHER_01 LAUNCHER_02 LAUNCHER_03 LOGVIEWER_01 NETEX_01 NETEX_02 NETEX_03 NETEX_04 NETEX_05 NETEX_06 NETEX_07 NETVIEW_01 NETVIEW_02 NETVIEW_SETUP NHC_01 NHC_02 NHC_03 NHM_01_02 NHM_04 NHM_05 NHM_06 NHM_07 NHM_08 NHM_09 NHM_10 NHM_11 NHM_12 NHM_13 NODECLI_01 NODESEC_15 OPS_01 PARMGT_01 PARMGT_02 PARMGT_03 PARMGT_04 PLM_01 PM_02 PM_03 PM_04 PM_11 PM_13 PM_15 PM_16 PM_17 PM_19 PM_20 PM_24 PM_25 PM_26 PM_27 PM_29 PM_30 PM_31 PM_32 PM_34 PM_38 PM_40 PM_42 PM_46 PM_47 PM_50 PM_51 PM_52 PM_54 PM_55 PM_56 PM_57 PM_58 PM_59 PM_60 PM_61 PM_62 PM_63 PM_64 PM_65 PM_66 PM_67 PM_68 PM_69 PM_71 PM_72 PM_73 PM_74 PM_75 PM_76 PM_77 PM_78 PM_79 PM_80 PM_81 PM_82 PM_83 PM_84 PM_85 PM_86 PM_87 PM_88 PM_89 PM_90 PM_91 PM_92 PM_93 SECUI_01 SECUI_02 SECUI_03 SECUI_05 SECUI_06 SECUI_07 SECUI_08 SECUI_09 SECUI_10 SECUI_11 SECUI_12 SHM_01 SHM_02 SHM_03 SHM_04 SHM_05 SHM_06 SHM_07 SHM_19 SHM_20 SHM_21 SHM_23 SHM_27 SHM_28 SHM_31 SHM_32 SHM_33 SHM_34 SHM_35 SHM_36 SHM_37 SHM_39 SHM_40 SHM_41 SHM_42 SHM_43 SHM_SETUP TOP_01"
        contact_groups  623admins
        }

