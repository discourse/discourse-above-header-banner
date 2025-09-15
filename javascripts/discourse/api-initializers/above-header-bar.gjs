import { apiInitializer } from "discourse/lib/api";
import CustomAboveHeaderBar from "../components/custom-above-header-bar";

export default apiInitializer((api) => {
  api.renderInOutlet("after-header", CustomAboveHeaderBar);
});
