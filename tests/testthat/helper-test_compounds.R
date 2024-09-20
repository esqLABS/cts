try({
rifampicin <- compound(test_path("data/Rifampicin-Model.json"))
midazolam <- compound(test_path("data/Midazolam-Model.json"))
levonorgestrel <- compound(test_path("data/Levonorgestrel-Model.json"))
itraconazole <- compound(test_path("data/Itraconazole-Model.json"))
itraconazole80 <- compound(test_path("data/Itraconazole-Model-80.json"))

levo_itra_ddi <- import_ddi(test_path("data/Levonorgestrel-Itraconazole-DDI.json"))
}, silent = T)
