import * as Turbo from "@hotwired/turbo-rails"
window.Turbo = Turbo

import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

window.Stimulus = Application.start();
eagerLoadControllersFrom("controllers", Stimulus);