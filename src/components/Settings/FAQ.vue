<template>
  <div class="FAQ bb-content h-100">
    <div class="x-header">
      <x-header :left-options="{preventGoBack:true}" @on-click-back="$router.replace({name:'Setting'})"></x-header>
    </div>
    <div class="content bb-content h-100 tl pd-40">
      <section class="wrapper bb-content h-100">
        <p class="strong mb">尊敬的用户：</p>

        <p class="strong mb">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbspFAQ</p>

        <section class="terms-area">
          <h2>FOF钱包的作用？</h2>
          <ul class="strong">
            <li>钱包是一种管理用户FOF账户的工具。在钱包里你可以添加多个FOF账户进行管理。</li></br>
          </ul>
        </section>
        <section class="terms-area">
          <h2>如何备份自己的FOF钱包？</h2>
          <ul class="strong">
            <li>FOF钱包的密码和Keystore是您登陆钱包的唯一方式，一旦遗失您很可能再也找不回您的FOF钱包。</li></br>
            <li>
              <p >Keystore的备份方法如下：</p>
              <ul class="strong">
                <li>1.用户一开始创建完FOF钱包，可备份钱包的Keystore后再进入FOF钱包。</li>
                <li>2.没有备份却已经进入FOF钱包的用户可在“钱包设置”里进行备份保存。 </li>
                <li>3.用户退出登录时会提示用户备份后再退出FOF钱包。 </li></br>
              </ul>
            </li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>什么是FOF账户？</h2>
          <ul>
            <li>FOF账户可以管理用户的资产。用户也可以通过FOF账户进行创建应用、投票、转账、游戏……等操作。</li></br>
          </ul>
        </section>
        <section class="terms-area">
          <h2>FOF账户的作用？</h2>
          <ul>
            <li>
              <p >用户可进入自己的FOF账户内选择备份方式：</p>
              <ul class="strong">
                <li>1.备份私钥：用户可以使用私钥在FOF钱包中绑定该私钥对应的FOF账户，私钥也是用户遗忘助记词和Keystore后找回账户的唯一方法。私钥的丢失可能会导致您的资产遭受损失且不能再找回FOF账户，所以请务必保管好自己的FOF账户私钥。</li>
                <li>2.备份助记词：用户备份的助记词可用于恢复FOF账户和修改FOF钱包密码。 </li>
                <li>3.备份Keystore：仅可用于恢复FOF账户。</li></br>
              </ul>
            </li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>FOF的游戏？</h2>
          <ul class="strong">
            <li>
              为保证游戏的公平、公开、公正，用户所玩的所有游戏，FOF都已开放源码可查。且用户可前往“我的应用”根据提示创建游戏自行当庄。
            </li></br>
          </ul>
        </section>
        <section class="terms-area">
        </section>
        <p class="strong right last tr">
          fofgame.io
        </p>
      </section>
    </div>
  </div>
</template>

<script>

  export default {
    name: "Agreement",
    data() {
      return {
        pwd: '',
        confirmPwd: '',
        agreement:false,
      }
    }
  }
</script>

<style lang="less" scoped>
  .agreement {
    padding-top: 120px;

    .content {
      .wrapper {
        overflow-y: auto;
        padding: 40px;
        border: 1px solid rgba(222,222,222,1);
        border-radius: 20px;
      }
    }
  }
  p, li {
    line-height: 1.5;
  }
  p, li, .mb, h2, h3, h4, h5 {
    margin-bottom: 20px;
    font-size: @base-font-size;
  }
  .strong {
    font-size: 60px;
  }
  .right {
    text-align: right;
  }
  .square {
    list-style: square;
    margin-left: 1rem;
  }
</style>
