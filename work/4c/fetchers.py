from voxsup.pinterest.ads import pinterest_refresh_ad_account
ea = pinterest_refresh_ad_account.apply(args=['549755814145'], kwargs={'force': 'true'})

from voxsup.pinterest.ads import pinterest_fetch_campaigns
ea = pinterest_fetch_campaigns.apply(args=['549755814145', ['626739728789']], kwargs={'verbose_failures': 'true'})
