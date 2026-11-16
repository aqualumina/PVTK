.class public Lcom/hz/en/AutoQuest;
.super Ljava/lang/Object;

.field public static volatile farmEnabled:Z
.field private static lastTickMs:J
.field private static lastBattleSkipMs:J
.field private static farmStepDir:I

.method static constructor <clinit>()V
    .locals 3

    const/4 v0, 0x0

    sput-boolean v0, Lcom/hz/en/AutoQuest;->farmEnabled:Z

    sput v0, Lcom/hz/en/AutoQuest;->farmStepDir:I

    const-wide/16 v1, 0x0

    sput-wide v1, Lcom/hz/en/AutoQuest;->lastTickMs:J

    sput-wide v1, Lcom/hz/en/AutoQuest;->lastBattleSkipMs:J

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static attachOverlay(Lcom/lori/app/PipActivity;)V
    .locals 1

    if-nez p0, :cond_0

    return-void

    :cond_0
    :try_start_0
    new-instance v0, Lcom/hz/en/AutoQuest$2;

    invoke-direct {v0, p0}, Lcom/hz/en/AutoQuest$2;-><init>(Lcom/lori/app/PipActivity;)V

    invoke-virtual {p0, v0}, Lcom/lori/app/PipActivity;->runOnUiThread(Ljava/lang/Runnable;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method private static makePill(Lcom/lori/app/PipActivity;F)Landroid/widget/TextView;
    .locals 3

    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v1, 0x41300000    # 11.0f

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v1, 0x1

    invoke-static {v1}, Landroid/graphics/Typeface;->defaultFromStyle(I)Landroid/graphics/Typeface;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/high16 v1, 0x41100000    # 9.0f

    mul-float/2addr v1, p1

    float-to-int v1, v1

    const/high16 v2, 0x40a00000    # 5.0f

    mul-float/2addr v2, p1

    float-to-int v2, v2

    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object v0
.end method

.method public static attachOverlayOnUi(Lcom/lori/app/PipActivity;)V
    .locals 8

    if-nez p0, :cond_0

    return-void

    :cond_0
    :try_start_0
    invoke-virtual {p0}, Lcom/lori/app/PipActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    if-nez v0, :cond_1

    return-void

    :cond_1
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    const v1, 0x1020002

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    instance-of v1, v0, Landroid/widget/FrameLayout;

    if-nez v1, :cond_2

    return-void

    :cond_2
    check-cast v0, Landroid/widget/FrameLayout;

    const-string v1, "PVTK_AQ_BTN"

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :cond_3

    invoke-virtual {v0, v2}, Landroid/widget/FrameLayout;->removeView(Landroid/view/View;)V

    :cond_3
    invoke-virtual {p0}, Lcom/lori/app/PipActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    invoke-static {p0, v2}, Lcom/hz/en/AutoQuest;->makePill(Lcom/lori/app/PipActivity;F)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v3, v1}, Landroid/widget/TextView;->setTag(Ljava/lang/Object;)V

    invoke-static {v3}, Lcom/hz/en/AutoQuest;->updateFarmStyle(Landroid/widget/TextView;)V

    const/4 v4, 0x1

    new-instance v5, Lcom/hz/en/AutoQuest$1;

    invoke-direct {v5, v3, v0, v3, v4}, Lcom/hz/en/AutoQuest$1;-><init>(Landroid/widget/TextView;Landroid/widget/FrameLayout;Landroid/view/View;I)V

    invoke-virtual {v3, v5}, Landroid/widget/TextView;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v5, -0x2

    invoke-direct {v4, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/high16 v5, 0x41400000    # 12.0f

    mul-float/2addr v5, v2

    float-to-int v5, v5

    iput v5, v4, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    const/high16 v5, 0x42f00000    # 120.0f

    mul-float/2addr v5, v2

    float-to-int v2, v5

    iput v2, v4, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v3, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method public static declared-synchronized toggleFarm(Landroid/widget/TextView;)V
    .locals 4

    const-class v0, Lcom/hz/en/AutoQuest;

    monitor-enter v0

    :try_start_0
    sget-boolean v1, Lcom/hz/en/AutoQuest;->farmEnabled:Z

    if-eqz v1, :cond_0

    const/4 v1, 0x0

    sput-boolean v1, Lcom/hz/en/AutoQuest;->farmEnabled:Z

    goto :goto_0

    :cond_0
    const/4 v1, 0x1

    sput-boolean v1, Lcom/hz/en/AutoQuest;->farmEnabled:Z

    sput-boolean v1, Lcom/hz/main/GameWorld;->TAG_IS_AUTO_FIGHT_FLAG:Z

    const-wide/16 v2, 0x0

    sput-wide v2, Lcom/hz/en/AutoQuest;->lastTickMs:J

    :goto_0
    if-eqz p0, :cond_1

    invoke-static {p0}, Lcom/hz/en/AutoQuest;->updateFarmStyle(Landroid/widget/TextView;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_1
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0

    throw p0
.end method

.method private static updateFarmStyle(Landroid/widget/TextView;)V
    .locals 3

    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/high16 v1, 0x41900000    # 18.0f

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    sget-boolean v1, Lcom/hz/en/AutoQuest;->farmEnabled:Z

    if-eqz v1, :cond_0

    const v1, -0x332688fa

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/4 v1, 0x2

    const v2, -0x77000001

    invoke-virtual {v0, v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    const-string v1, "AF: ON"

    invoke-virtual {p0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    :cond_0
    const v1, -0x44ddd7cf

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/4 v1, 0x2

    const v2, -0x77777778

    invoke-virtual {v0, v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    const-string v1, "AF: OFF"

    invoke-virtual {p0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :goto_0
    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    return-void
.end method

.method public static onBattleTick(Lcom/hz/battle/BattleAniEngine;)V
    .locals 8

    sget-boolean v0, Lcom/hz/en/AutoQuest;->farmEnabled:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    if-nez p0, :cond_1

    return-void

    :cond_1
    const/4 v0, 0x1

    sput-boolean v0, Lcom/hz/main/GameWorld;->TAG_IS_AUTO_FIGHT_FLAG:Z

    const/16 v1, 0x1000

    :try_start_0
    invoke-virtual {p0, v1, v0}, Lcom/hz/battle/BattleAniEngine;->setTag(IZ)V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-virtual {p0}, Lcom/hz/battle/BattleAniEngine;->isEndCounter()Z

    move-result v3

    if-eqz v3, :cond_4

    sget-wide v3, Lcom/hz/main/GameWorld;->nextBattleTime:J

    const-wide/16 v5, 0x9c4

    sub-long/2addr v3, v5

    cmp-long v0, v1, v3

    if-gez v0, :cond_2

    return-void

    :cond_2
    invoke-virtual {p0}, Lcom/hz/battle/BattleAniEngine;->doExit()V

    const-wide/16 v3, 0xbb8

    add-long/2addr v1, v3

    sget-wide v3, Lcom/hz/main/GameWorld;->nextBattleTime:J

    cmp-long v0, v3, v1

    if-gez v0, :cond_3

    sput-wide v1, Lcom/hz/main/GameWorld;->nextBattleTime:J

    :cond_3
    return-void

    :cond_4
    invoke-virtual {p0, v0}, Lcom/hz/battle/BattleAniEngine;->isTag(I)Z

    move-result v0

    if-eqz v0, :cond_6

    sput-wide v1, Lcom/hz/en/AutoQuest;->lastBattleSkipMs:J

    iget-object v0, p0, Lcom/hz/battle/BattleAniEngine;->battlePanel:Lcom/hz/battle/BattlePanel;

    if-eqz v0, :cond_5

    invoke-virtual {v0}, Lcom/hz/battle/BattlePanel;->triggerAutoFight()V

    :cond_5
    return-void

    :cond_6
    sget-wide v3, Lcom/hz/en/AutoQuest;->lastBattleSkipMs:J

    const-wide/16 v5, 0x0

    cmp-long v0, v3, v5

    if-nez v0, :cond_7

    sput-wide v1, Lcom/hz/en/AutoQuest;->lastBattleSkipMs:J

    return-void

    :cond_7
    sub-long v3, v1, v3

    const-wide/16 v5, 0x9c4

    cmp-long v0, v3, v5

    if-gez v0, :cond_8

    return-void

    :cond_8
    const-wide/16 v5, 0x1194

    cmp-long v0, v3, v5

    if-gez v0, :cond_9

    sget-object v0, Lcom/hz/main/GameWorld;->myPlayer:Lcom/hz/actor/Player;

    if-eqz v0, :cond_9

    iget-object v0, v0, Lcom/hz/actor/Player;->battlePlanControlList:Ljava/util/Vector;

    if-eqz v0, :cond_9

    invoke-virtual {v0}, Ljava/util/Vector;->size()I

    move-result v0

    if-lez v0, :cond_9

    return-void

    :cond_9
    sput-wide v1, Lcom/hz/en/AutoQuest;->lastBattleSkipMs:J

    invoke-virtual {p0}, Lcom/hz/battle/BattleAniEngine;->closePlayerAnimation()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method private static hasBlockingUI()Z
    .locals 4

    invoke-static {}, Lcom/hz/ui/UIHandler;->hasUI()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    :cond_0
    invoke-static {}, Lcom/hz/ui/UIHandler;->getTopUI()Lcom/hz/ui/UIHandler;

    move-result-object v0

    if-nez v0, :cond_1

    return v1

    :cond_1
    invoke-virtual {v0}, Lcom/hz/ui/UIHandler;->getType()I

    move-result v0

    const/16 v2, 0xd5

    const/4 v3, 0x1

    if-eq v0, v2, :cond_2

    const/16 v2, 0xda

    if-eq v0, v2, :cond_2

    return v3

    :cond_2
    return v1
.end method

.method private static doAutoFarm(Lcom/hz/actor/Player;)V
    .locals 7

    if-nez p0, :cond_0

    return-void

    :cond_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/hz/main/GameWorld;->nextBattleTime:J

    cmp-long v0, v0, v2

    if-gez v0, :cond_1

    return-void

    :cond_1
    const/4 v0, 0x1

    sput-boolean v0, Lcom/hz/main/GameWorld;->TAG_IS_AUTO_FIGHT_FLAG:Z

    invoke-static {}, Lcom/hz/main/GameWorld;->getNPCList()[Lcom/hz/actor/NPC;

    move-result-object v1

    const/4 v2, 0x0

    if-eqz v1, :cond_5

    array-length v3, v1

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v3, :cond_5

    aget-object v5, v1, v4

    if-eqz v5, :cond_4

    invoke-virtual {v5}, Lcom/hz/actor/NPC;->isEnable()Z

    move-result v6

    if-eqz v6, :cond_4

    iget-byte v6, v5, Lcom/hz/actor/NPC;->npcType:B

    if-ne v6, v0, :cond_4

    invoke-virtual {v5}, Lcom/hz/actor/NPC;->isVisible()Z

    move-result v6

    if-nez v6, :cond_2

    invoke-virtual {v5, v0}, Lcom/hz/actor/NPC;->setVisible(Z)V

    :cond_2
    iget-object v5, v5, Lcom/hz/actor/NPC;->battleID:[S

    if-eqz v5, :cond_4

    array-length v6, v5

    if-lez v6, :cond_4

    aget-short v5, v5, v2

    if-lez v5, :cond_4

    invoke-static {v5, v0}, Lcom/hz/main/GameWorld;->toBattle(IZ)Z

    move-result v5

    if-eqz v5, :cond_4

    return-void

    :cond_4
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_5
    sget v0, Lcom/hz/en/AutoQuest;->farmStepDir:I

    rem-int/lit8 v1, v0, 0x2

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/hz/en/AutoQuest;->farmStepDir:I

    if-nez v1, :cond_6

    const/16 v0, 0x18

    goto :goto_1

    :cond_6
    const/16 v0, -0x18

    :goto_1
    invoke-static {p0, v0, v2, v2}, Lcom/hz/main/WorldPanel;->handleMoveKey(Lcom/hz/actor/Player;IIB)V

    return-void
.end method

.method public static onWorldTick()V
    .locals 6

    sget-boolean v0, Lcom/hz/en/AutoQuest;->farmEnabled:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    :try_start_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/hz/en/AutoQuest;->lastTickMs:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x4b0

    cmp-long v2, v2, v4

    if-gez v2, :cond_1

    return-void

    :cond_1
    sput-wide v0, Lcom/hz/en/AutoQuest;->lastTickMs:J

    sget-boolean v0, Lcom/hz/main/MsgHandler;->isRequestWaiting:Z

    if-eqz v0, :cond_2

    return-void

    :cond_2
    sget-object v0, Lcom/hz/main/GameWorld;->myPlayer:Lcom/hz/actor/Player;

    if-nez v0, :cond_3

    return-void

    :cond_3
    sget-object v1, Lcom/hz/main/GameCanvas;->battle:Lcom/hz/battle/Battle;

    if-eqz v1, :cond_4

    const/4 v0, 0x1

    sput-boolean v0, Lcom/hz/main/GameWorld;->TAG_IS_AUTO_FIGHT_FLAG:Z

    return-void

    :cond_4
    invoke-virtual {v0}, Lcom/hz/actor/Player;->isAutoMove()Z

    move-result v1

    if-eqz v1, :cond_5

    return-void

    :cond_5
    invoke-static {}, Lcom/hz/en/AutoQuest;->hasBlockingUI()Z

    move-result v1

    if-nez v1, :cond_6

    invoke-static {v0}, Lcom/hz/en/AutoQuest;->doAutoFarm(Lcom/hz/actor/Player;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_6
    return-void
.end method
