from brownie import accounts, Market


def deploy():
    account = accounts[0]
    market = Market.deploy({"from": account})


def main():
    deploy()
