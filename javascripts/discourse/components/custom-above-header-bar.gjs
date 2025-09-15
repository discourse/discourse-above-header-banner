import Component from "@glimmer/component";
import { service } from "@ember/service";
import icon from "discourse/helpers/d-icon";
import DiscourseURL from "discourse/lib/url";
import { i18n } from "discourse-i18n";

export default class CustomAboveHeaderBar extends Component {
  @service currentUser;

  get bannerLink() {
    return this.currentUser
      ? settings.member_banner_link
      : settings.anon_banner_link;
  }

  get bannerText() {
    return this.currentUser
      ? i18n(themePrefix("member_banner_text"))
      : i18n(themePrefix("anon_banner_text"));
  }

  get bannerCtaText() {
    return this.currentUser
      ? i18n(themePrefix("member_cta_text"))
      : i18n(themePrefix("anon_cta_text"));
  }

  get shouldOpenInNewTab() {
    const url = this.bannerLink;

    if (this.currentUser) {
      return (
        this.currentUser.user_option?.external_links_in_new_tab &&
        !DiscourseURL.isInternal(url)
      );
    } else {
      return settings.open_in_new_tab;
    }
  }

  <template>
    <div class="custom-header-bar">
      <div class="wrap">
        <div class="custom-header-bar__contents">
          <a
            href={{this.bannerLink}}
            target={{if this.shouldOpenInNewTab "_blank"}}
            rel={{if this.shouldOpenInNewTab "noopener"}}
          >
            {{this.bannerText}}
            <span>
              {{this.bannerCtaText}}
              {{icon "up-right-from-square"}}
            </span>
          </a>
        </div>
      </div>
    </div>
  </template>
}
