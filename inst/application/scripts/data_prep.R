vars_of_interest <- c(
  paste0("f", 1:4),
  paste0("of_", 1:12)
)

scale_to_10 <- function(x){
  x %>% 
    `-`(min(x)) %>% 
    `/`(max(x)-min(x)) %>% 
    `*`(10)
}
identify_bottom_25 <- function(x){
  x < quantile(x, probs = .25)
}
leykam_survey04 <- read_dta("~/Documents/Apps/Leykam/data/leykam_survey04.dta")

leykam_survey06 <- haven::read_dta("~/Tresors/Allgemein/Kunden/High5Data/7_Leykam_Daten/leykam_survey06.dta")

laender_agg_dta <- leykam_survey06 %>% 
  mutate(
    across(all_of(vars_of_interest), identify_bottom_25, .names = "below_25_{col}")
  ) %>% 
  group_by(state) %>% 
  summarise(
    across(ends_with("_sc"), mean, na.rm = TRUE),
    across(ends_with("_sc_cat"), mean, na.rm = TRUE),
    across(starts_with("below"), mean, na.rm = TRUE, .names = "{col}_ratio")
  ) %>% 
  mutate(name = names(attr(state,"label"))[state],
         .before = 1,
         .keep = "unused")


bezirke <- readOGR("./GeoJSON/BEZIRKSGRENZEOGD.json",
                   use_iconv = TRUE,
                   encoding = "UTF-8") %>%
  st_as_sf() %>%
  select(name = NAMEK, id = BEZNR, geometry)
bezirk_agg_dta <- leykam_survey06 %>% 
  filter(!is.na(citydistrict)) %>% 
  mutate(
    across(all_of(vars_of_interest), identify_bottom_25, .names = "below_25_{col}")
  ) %>%
  group_by(citydistrict) %>% 
  summarise(
    across(ends_with("_sc_ci"), mean, na.rm = TRUE),
    across(ends_with("_ci_cat"), mean, na.rm = TRUE),
    across(starts_with("below"), mean, na.rm = TRUE, .names = "{col}_ratio")
  ) %>% 
  rename(id = citydistrict) %>% 
  rename_all(~gsub("_ci","",.)) %>% 
  inner_join(sf::st_set_geometry(bezirke, NULL) )
laender <- readOGR("./GeoJSON/2017/simplified-95/laender_95_geo.json",
                   use_iconv = TRUE,
                   encoding = "UTF-8") %>%
  st_as_sf() %>% 
  rename(id = iso) %>% 
  mutate(id = as.numeric(id))

laender_agg_map_dta <- inner_join(laender, laender_agg_dta) %>% 
  mutate(ratio_default = 1)
bezirke_agg_map_dta <- inner_join(bezirke, bezirk_agg_dta) %>% 
  mutate(ratio_default = 1)

saveRDS(bezirk_agg_dta, "data/bezirk_agg_dta.rds")
saveRDS(laender_agg_dta, "data/laender_agg_dta.rds")
saveRDS(bezirke_agg_map_dta, "data/bezirke_agg_map_dta.rds")
saveRDS(laender_agg_map_dta, "data/laender_agg_map_dta.rds")

