.class public Lcom/hz/en/Translator;
.super Ljava/lang/Object;

.field private static idMap:Ljava/util/HashMap;
.field private static loaded:Z
.field private static missed:Ljava/util/HashSet;
.field private static textMap:Ljava/util/HashMap;

.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/hz/en/Translator;->loaded:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static declared-synchronized ensureLoaded()V
    .locals 8

    const-class v7, Lcom/hz/en/Translator;

    monitor-enter v7

    :try_start_0
    sget-boolean v5, Lcom/hz/en/Translator;->loaded:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v5, :cond_0

    :goto_0
    monitor-exit v7

    return-void

    :cond_0
    const/4 v5, 0x1

    :try_start_1
    sput-boolean v5, Lcom/hz/en/Translator;->loaded:Z

    new-instance v5, Ljava/util/HashMap;

    invoke-direct {v5}, Ljava/util/HashMap;-><init>()V

    sput-object v5, Lcom/hz/en/Translator;->idMap:Ljava/util/HashMap;

    new-instance v5, Ljava/util/HashMap;

    invoke-direct {v5}, Ljava/util/HashMap;-><init>()V

    sput-object v5, Lcom/hz/en/Translator;->textMap:Ljava/util/HashMap;

    new-instance v5, Ljava/util/HashSet;

    invoke-direct {v5}, Ljava/util/HashSet;-><init>()V

    sput-object v5, Lcom/hz/en/Translator;->missed:Ljava/util/HashSet;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    sget-object v0, Lcom/lori/app/PipActivity;->DEFAULT_ACTIVITY:Lcom/lori/app/PipActivity;

    if-eqz v0, :cond_3

    invoke-static {}, Lcom/hz/en/OtaPatcher;->startBackgroundCheck()V

    invoke-static {v0}, Lcom/hz/en/OtaPatcher;->openDictStream(Landroid/content/Context;)Ljava/io/InputStream;

    move-result-object v1

    new-instance v0, Ljava/io/BufferedReader;

    new-instance v5, Ljava/io/InputStreamReader;

    const-string v6, "UTF-8"

    invoke-direct {v5, v1, v6}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v0, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    :cond_1
    :goto_1
    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_2

    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V

    const-string v5, "PVTK_TR"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v1, "Loaded dict: id="

    invoke-direct {v6, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Lcom/hz/en/Translator;->idMap:Ljava/util/HashMap;

    invoke-virtual {v1}, Ljava/util/HashMap;->size()I

    move-result v1

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v1, " text="

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    sget-object v1, Lcom/hz/en/Translator;->textMap:Ljava/util/HashMap;

    invoke-virtual {v1}, Ljava/util/HashMap;->size()I

    move-result v1

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catch Ljava/lang/Throwable; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_0

    :catch_0
    move-exception v0

    :try_start_3
    const-string v5, "PVTK_TR"

    const-string v6, "Failed to load dict_en.txt"

    invoke-static {v5, v6, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v5

    monitor-exit v7

    throw v5

    :cond_2
    const/16 v5, 0x9

    :try_start_4
    invoke-virtual {v2, v5}, Ljava/lang/String;->indexOf(I)I

    move-result v3

    if-lez v3, :cond_1

    const/16 v5, 0x9

    add-int/lit8 v6, v3, 0x1

    invoke-virtual {v2, v5, v6}, Ljava/lang/String;->indexOf(II)I

    move-result v4

    if-ltz v4, :cond_1

    const/4 v5, 0x0

    invoke-virtual {v2, v5, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    add-int/lit8 v5, v3, 0x1

    invoke-virtual {v2, v5, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/hz/en/Translator;->unescape(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    add-int/lit8 v5, v4, 0x1

    invoke-virtual {v2, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/hz/en/Translator;->unescape(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "T"

    invoke-virtual {v5, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_4

    sget-object v5, Lcom/hz/en/Translator;->textMap:Ljava/util/HashMap;

    invoke-virtual {v5, v3, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_1

    :cond_4
    sget-object v5, Lcom/hz/en/Translator;->idMap:Ljava/util/HashMap;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, ":"

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_4
    .catch Ljava/lang/Throwable; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto/16 :goto_1

    :cond_3
    goto/16 :goto_0
.end method

.method private static hasNonAscii(Ljava/lang/String;)Z
    .locals 5

    const/4 v2, 0x0

    if-nez p0, :cond_1

    :cond_0
    :goto_0
    return v2

    :cond_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v0, 0x0

    :goto_1
    if-ge v0, v1, :cond_0

    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v3

    const/16 v4, 0x7f

    if-le v3, v4, :cond_2

    const/4 v2, 0x1

    goto :goto_0

    :cond_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1
.end method

.method private static logMiss(Ljava/lang/String;Ljava/lang/String;)V
    .locals 4

    :try_start_0
    sget-object v0, Lcom/hz/en/Translator;->missed:Ljava/util/HashSet;

    if-eqz v0, :cond_0

    invoke-virtual {v0, p1}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Ljava/util/HashSet;->size()I

    move-result v1

    const/16 v2, 0x7d0

    if-ge v1, v2, :cond_0

    invoke-virtual {v0, p1}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    invoke-static {p0, p1}, Lcom/hz/en/MissReporter;->queue(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "PVTK_TR_MISS"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v2, "\t"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\n"

    const-string v3, "\\n"

    invoke-virtual {p1, v2, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :cond_0
    :goto_0
    return-void

    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method private static trArray([Ljava/lang/String;)V
    .locals 3

    if-nez p0, :cond_1

    :cond_0
    return-void

    :cond_1
    array-length v1, p0

    const/4 v0, 0x0

    :goto_0
    if-ge v0, v1, :cond_0

    aget-object v2, p0, v0

    invoke-static {v2}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    aput-object v2, p0, v0

    add-int/lit8 v0, v0, 0x1

    goto :goto_0
.end method

.method private static trByIdOrText(Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;
    .locals 3

    if-eqz p2, :cond_0

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_1

    :cond_0
    :goto_0
    return-object p2

    :cond_1
    invoke-static {}, Lcom/hz/en/Translator;->ensureLoaded()V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v2, ":"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcom/hz/en/Translator;->idMap:Ljava/util/HashMap;

    if-eqz v1, :cond_2

    invoke-virtual {v1, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    if-eqz v1, :cond_2

    move-object p2, v1

    goto :goto_0

    :cond_2
    sget-object v1, Lcom/hz/en/Translator;->textMap:Ljava/util/HashMap;

    if-eqz v1, :cond_3

    invoke-virtual {v1, p2}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    if-eqz v1, :cond_3

    move-object p2, v1

    goto :goto_0

    :cond_3
    invoke-static {p2}, Lcom/hz/en/Translator;->hasNonAscii(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-static {v0, p2}, Lcom/hz/en/Translator;->logMiss(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public static trItem(Lcom/hz/core/Item;)V
    .locals 3

    if-nez p0, :cond_0

    :goto_0
    return-void

    :cond_0
    const-string v0, "I"

    iget v1, p0, Lcom/hz/core/Item;->id:I

    iget-object v2, p0, Lcom/hz/core/Item;->name:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcom/hz/en/Translator;->trByIdOrText(Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Item;->name:Ljava/lang/String;

    const-string v0, "ID"

    iget-object v2, p0, Lcom/hz/core/Item;->info:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcom/hz/en/Translator;->trByIdOrText(Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Item;->info:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/core/Item;->skillDesc:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Item;->skillDesc:Ljava/lang/String;

    goto :goto_0
.end method

.method public static trMission(Lcom/hz/core/Mission;)V
    .locals 1

    if-nez p0, :cond_0

    :goto_0
    return-void

    :cond_0
    iget-object v0, p0, Lcom/hz/core/Mission;->name:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Mission;->name:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/core/Mission;->simpleDesc:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Mission;->simpleDesc:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/core/Mission;->desc:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Mission;->desc:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/core/Mission;->dialogNotStartNotReady:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Mission;->dialogNotStartNotReady:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/core/Mission;->dialogStartNotFinish:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Mission;->dialogStartNotFinish:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/core/Mission;->dialogStartFinish:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Mission;->dialogStartFinish:Ljava/lang/String;

    goto :goto_0
.end method

.method public static trMonster(Lcom/hz/actor/Monster;)V
    .locals 1

    if-nez p0, :cond_0

    :goto_0
    return-void

    :cond_0
    iget-object v0, p0, Lcom/hz/actor/Monster;->name:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/actor/Monster;->name:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/actor/Monster;->message:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/actor/Monster;->message:Ljava/lang/String;

    goto :goto_0
.end method

.method public static trNPC(Lcom/hz/actor/NPC;)V
    .locals 1

    if-nez p0, :cond_0

    :goto_0
    return-void

    :cond_0
    iget-object v0, p0, Lcom/hz/actor/NPC;->name:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/actor/NPC;->name:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/actor/NPC;->welcome:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/actor/NPC;->welcome:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/actor/NPC;->talkDetail:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/actor/NPC;->talkDetail:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/actor/NPC;->topic:Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trText(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/actor/NPC;->topic:Ljava/lang/String;

    iget-object v0, p0, Lcom/hz/actor/NPC;->menuJumpMap:[Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trArray([Ljava/lang/String;)V

    iget-object v0, p0, Lcom/hz/actor/NPC;->menuBattle:[Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trArray([Ljava/lang/String;)V

    iget-object v0, p0, Lcom/hz/actor/NPC;->menuShop:[Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trArray([Ljava/lang/String;)V

    iget-object v0, p0, Lcom/hz/actor/NPC;->menuTeacher:[Ljava/lang/String;

    invoke-static {v0}, Lcom/hz/en/Translator;->trArray([Ljava/lang/String;)V

    goto :goto_0
.end method

.method public static trSkill(Lcom/hz/core/Skill;)V
    .locals 3

    if-nez p0, :cond_0

    :goto_0
    return-void

    :cond_0
    const-string v0, "S"

    iget v1, p0, Lcom/hz/core/Skill;->id:I

    iget-object v2, p0, Lcom/hz/core/Skill;->name:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcom/hz/en/Translator;->trByIdOrText(Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Skill;->name:Ljava/lang/String;

    const-string v0, "SD"

    iget-object v2, p0, Lcom/hz/core/Skill;->info:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcom/hz/en/Translator;->trByIdOrText(Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/hz/core/Skill;->info:Ljava/lang/String;

    goto :goto_0
.end method

.method public static trText(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_1

    :cond_0
    :goto_0
    return-object p0

    :cond_1
    invoke-static {}, Lcom/hz/en/Translator;->ensureLoaded()V

    sget-object v1, Lcom/hz/en/Translator;->textMap:Ljava/util/HashMap;

    if-eqz v1, :cond_2

    invoke-virtual {v1, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    if-eqz v0, :cond_trim

    move-object p0, v0

    goto :goto_0

    :cond_trim
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    if-eqz v1, :cond_2

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_2
    invoke-static {p0}, Lcom/hz/en/Translator;->hasNonAscii(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "T"

    invoke-static {v1, p0}, Lcom/hz/en/Translator;->logMiss(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method private static unescape(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    if-nez p0, :cond_1

    const/4 p0, 0x0

    :cond_0
    :goto_0
    return-object p0

    :cond_1
    const/16 v0, 0x5c

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    if-ltz v0, :cond_0

    const-string v0, "\\n"

    const-string v1, "\n"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "\\t"

    const-string v1, "\t"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    goto :goto_0
.end method
