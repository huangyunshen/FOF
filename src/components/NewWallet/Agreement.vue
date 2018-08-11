<template>
  <div class="agreement">
    <div class="header">
      <x-header :left-options="{preventGoBack:true}" @on-click-back="$router.replace({name:'CreateWallet'})"></x-header>
    </div>
    <div class="content tl pd-40">
      <section class="wrapper">
        <p class="strong mb">尊敬的用户：</p>

        <p class="strong mb">感谢您选择FOF服务。此FOF基金会用户协议（“协议”）是一份法律文件，解释了您作为FOF基金会的订户的权利和义务。请仔细阅读。</p>

        <section class="terms-area">
          <h2>1.一般规定</h2>
          <ul class="strong">
            <li>FOF为您提供界面和工具，使您能够自行生成内容并将其提供给其他用户和/或FOF基金会。“用户生成的内容”是指您通过使用FOF的多用户功能或通过使用内容和服务或其他方式向FOF基金会或其附属公司提供给其他用户的任何内容。</li>
            <li>当您将内容上传到FOF以使其可供其他用户和/或FOF基金会使用时，您授予FOF基金会及其附属机构全球，非独家，使用，复制，修改，创建衍生作品，分发，传输的权利，转码，翻译，广播和以其他方式进行交流，公开展示和公开执行您的用户生成内容以及用户生成内容的衍生作品，以便操作，分发和推广FOF服务，FOF游戏或其他FOF基金会产品。该许可证授予FOF基金会，因为内容在整个知识产权期限内上传到FOF。根据FOF基金会在终止许可之前授予的任何子许可，终止上述许可不会影响任何次级被许可人的权利。FOF基金会是FOF基金会从您的内容创建的衍生作品的唯一所有者，因此有权授予这些衍生作品的许可。</li>
            <li>如果您向FOF基金会提供有关FOF，内容和服务或任何FOF产品或服务的任何反馈或建议，FOF基金会可以自由使用它所选择的反馈或建议，而无需向您负责。</li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>2.用户在FOF上生成应用</h2>
          <ul class="strong">
            <li>FOF上提供某些游戏或应用程序的生成允许您基于或使用FOF进行创建游戏或应用程序，并将该游戏或应用程序的数据提交给FOF。</li>
            <li>
              <p class="strong">您所生成的游戏或应用程序在配置上的任何设置，FOF基金会无权进行修改。</p>
              <ul class="strong">
                <li>（1）您所创建游戏或应用在配置上设置的失误和纰漏导致的损失FOF基金会概不负责。</li>
                <li>（2）因不可抗力、国家政策和FOF基金会内部决策使FOF暂停使用、维护。从而导致的损失FOF基金会不承担责任。 </li>
              </ul>
            </li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>3.内容上传到FOF</h2>
          <ul>
            <li>FOF上提供的某些游戏或应用程序允许您基于或使用FOF创建用户生成的内容，并将该用户生成的内容提交给FOF。共享应用可以由FOF应用查看，对于某些类别的共享应用，用户可以与其他用户交互，下载或购买。在某些情况下，可以考虑通过FOF或第三方开发人员将应用纳入游戏或市场。（除FOF中FOF币的交易其余交易FOF基金会不为其担保，用户之间除FOF币交易私下还有第三方交易或其他协议的FOF基金会不予认可也不为其承担任何责任。）</li>
            <li>具体的创建启用的应用程序或创建应用的网页可能包含补充或更改本节中所列条款的特殊条款（“特定于应用程序的条款”）。特别是，在研讨会贡献分发费用的情况下，特定于应用程序的条款将解决如何分享收入。除非在特定应用条款（如果有）中另有规定，否则以下一般规则适用于研讨会贡献。</li>
            <li>
              <p class="strong">尽管第1节中描述了许可证，但在下列情况下，FOF基金会仅有权修改或创建您的FOF的衍生作品：</p>
              <ul class="strong">
                <li>（1）可能需要进行修改以使您创建的应用与FOF的兼容功能或用户界面</li>
                <li>（2）FOF基金会或适用的开发人员可以对其在应用程序分发中接受的应用界面进行修改，因为它认为有必要或希望增强游戏性。</li>
              </ul>
              <p class="strong">您可以自行决定从适用的应用页面中删除应用。如果您这样做，FOF基金会将不再拥有使用，分发，传输，通信，公开展示或公开履行研讨会贡献的权利，除以下情况：</p>
              <ul class="strong">
                <li>（1）FOF基金会可以继续为任何可接受的应用创建行使这些权利。在游戏中分发或以允许在游戏中使用的方式分发</li>
                <li>（2）您的删除不会影响已经获得应用副本的任何使用者的权利。</li>
              </ul>
            </li>
            <li>除非在特定于应用程序的条款中另有规定，否则您同意FOF基金会对您的共享应用的考虑是您的全部补偿，并且您无权获得与FOF基金会和其他使用者授予的权利相关的任何其他权利或补偿。</li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>3. 促销和认可</h2>
          <ul>
            <li>如果您使用FOF基金会服务来宣传或认可产品，服务或活动，以换取第三方的任何形式的代价（包括免费游戏等非货币奖励） ，您必须向观众清楚地指出这种考虑的来源。</li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>4.陈述和保证</h2>
          <ul class="strong">
            <li>
              您向我们声明并保证，您在所有用户生成内容中拥有足够的权利，以授予FOF基金会和其他受影响方在上面的1和3中描述的许可。这包括但不限于受用户生成内容影响或包含的任何类型的知识产权或其他所有权或个人权利。特别是，对于应用共享，您声明并保证应用最初是由您创建的（或者，对于您和其他贡献者以外的其他人贡献的研讨会贡献，并且在这种情况下，您有权代表其他贡献者提交此类研讨会贡献）。
            </li>
            <li>
              您进一步声明并保证，用户生成的内容，您提交的内容以及您对该内容的授权不违反任何适用的合同，法律或法规。
            </li>
          </ul>
        </section>
        <section class="terms-area">
        </section>
        <p class="strong last">
          未尽事宜您需遵守FOF基金会不时更新的公告及相关规则，本协议最后更新于2018年7月3日（“修订日期”）。
        </p>
        <p class="strong right last tr">
          FOF基金会
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
    height: 100%;
    padding-top: 120px;
    box-sizing: border-box;

    .header {
      width: 100%;
      position: fixed;
      top: 0;
    }

    .content {
      height: 100%;
      box-sizing: border-box;

      .wrapper {
        height: 100%;
        box-sizing: border-box;
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
