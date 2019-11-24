library(magick)
library(bunny)

pills <- image_read("data-raw/pills_2.png") %>%
  image_trim()

bg_color <- "#fdfffc"
fg_color <- "#0a2239"

pills_hex <- image_canvas_hex(fill_color = bg_color) %>%
  image_composite(pills, gravity = "center", offset = "+0-100") %>%
  image_annotate("deals", gravity = "center", location = "+0+400", size=300, font="Aller", weight = 700, color = fg_color) %>%
  image_composite(image_canvas_hexborder(border_color = fg_color, border_size = 4))

pills_hex %>%
  image_scale("1200x1200") %>%
  image_write("data-raw/deals_hex.png", density = 600)

pills_hex %>%
  image_scale("200x200") %>%
  image_write("man/figures/logo.png", density = 600)

pills_hex_gh <- pills_hex %>%
  image_scale("400x400")

gh_logo <- bunny::github %>%
  image_scale("50x50")

pills_ghcard <- image_canvas_ghcard(fill_color = bg_color) %>%
  image_composite(pills_hex_gh, gravity = "East", offset = "+100+0") %>%
  image_annotate("The choice is yours", gravity = "West", location = "+60-30",
                 color=fg_color, size=60, font="Aller", weight = 700) %>%
  image_compose(gh_logo, gravity="West", offset = "+60+40") %>%
  image_annotate("dmi3kno/deals", gravity="West", location="+120+45",
                 size=50, font="Ubuntu Mono") %>%
  image_border_ghcard(bg_color)

pills_ghcard %>%
  image_write("data-raw/deals_ghcard.png", density = 600)


