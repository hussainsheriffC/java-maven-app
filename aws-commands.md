aws ec2 run-instances:
    --image-id ami-02f3f602d23f1659d
    --count 1
    --instance-type t2.micro
    --key-name mycliKey
    --security-group-ids sg-0682f90908edc477c
    --subnet-id subnet-042e1cdc714a6e219