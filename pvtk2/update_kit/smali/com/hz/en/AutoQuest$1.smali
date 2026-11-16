.class Lcom/hz/en/AutoQuest$1;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnTouchListener;

.field private dX:F
.field private dY:F
.field private startX:F
.field private startY:F
.field private moved:Z
.field final synthetic val$btn:Landroid/widget/TextView;
.field final synthetic val$root:Landroid/widget/FrameLayout;
.field final synthetic val$bar:Landroid/view/View;
.field final synthetic val$mode:I

.method constructor <init>(Landroid/widget/TextView;Landroid/widget/FrameLayout;Landroid/view/View;I)V
    .locals 0

    iput-object p1, p0, Lcom/hz/en/AutoQuest$1;->val$btn:Landroid/widget/TextView;

    iput-object p2, p0, Lcom/hz/en/AutoQuest$1;->val$root:Landroid/widget/FrameLayout;

    iput-object p3, p0, Lcom/hz/en/AutoQuest$1;->val$bar:Landroid/view/View;

    iput p4, p0, Lcom/hz/en/AutoQuest$1;->val$mode:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/hz/en/AutoQuest$1;->moved:Z

    return-void
.end method

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 5

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x1

    iget-object v2, p0, Lcom/hz/en/AutoQuest$1;->val$bar:Landroid/view/View;

    if-nez v0, :cond_0

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iput v0, p0, Lcom/hz/en/AutoQuest$1;->startX:F

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iput p2, p0, Lcom/hz/en/AutoQuest$1;->startY:F

    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/widget/FrameLayout$LayoutParams;

    iget v4, v3, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    int-to-float v4, v4

    sub-float/2addr v4, v0

    iput v4, p0, Lcom/hz/en/AutoQuest$1;->dX:F

    iget v0, v3, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    int-to-float v0, v0

    sub-float/2addr v0, p2

    iput v0, p0, Lcom/hz/en/AutoQuest$1;->dY:F

    const/4 p2, 0x0

    iput-boolean p2, p0, Lcom/hz/en/AutoQuest$1;->moved:Z

    return v1

    :cond_0
    const/4 v3, 0x2

    if-ne v0, v3, :cond_5

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iget v3, p0, Lcom/hz/en/AutoQuest$1;->startX:F

    sub-float v3, v0, v3

    invoke-static {v3}, Ljava/lang/Math;->abs(F)F

    move-result v3

    const/high16 v4, 0x41200000    # 10.0f

    cmpl-float v3, v3, v4

    if-gtz v3, :cond_1

    iget v3, p0, Lcom/hz/en/AutoQuest$1;->startY:F

    sub-float v3, p2, v3

    invoke-static {v3}, Ljava/lang/Math;->abs(F)F

    move-result v3

    cmpl-float v3, v3, v4

    if-lez v3, :cond_4

    :cond_1
    iput-boolean v1, p0, Lcom/hz/en/AutoQuest$1;->moved:Z

    iget v3, p0, Lcom/hz/en/AutoQuest$1;->dX:F

    add-float/2addr v0, v3

    float-to-int v0, v0

    iget v3, p0, Lcom/hz/en/AutoQuest$1;->dY:F

    add-float/2addr p2, v3

    float-to-int p2, p2

    if-gez v0, :cond_2

    const/4 v0, 0x0

    :cond_2
    if-gez p2, :cond_3

    const/4 p2, 0x0

    :cond_3
    iget-object v3, p0, Lcom/hz/en/AutoQuest$1;->val$root:Landroid/widget/FrameLayout;

    invoke-virtual {v3}, Landroid/widget/FrameLayout;->getWidth()I

    move-result v3

    invoke-virtual {v2}, Landroid/view/View;->getWidth()I

    move-result v4

    sub-int/2addr v3, v4

    if-lez v3, :cond_6

    if-le v0, v3, :cond_6

    move v0, v3

    :cond_6
    iget-object v3, p0, Lcom/hz/en/AutoQuest$1;->val$root:Landroid/widget/FrameLayout;

    invoke-virtual {v3}, Landroid/widget/FrameLayout;->getHeight()I

    move-result v3

    invoke-virtual {v2}, Landroid/view/View;->getHeight()I

    move-result v4

    sub-int/2addr v3, v4

    if-lez v3, :cond_7

    if-le p2, v3, :cond_7

    move p2, v3

    :cond_7
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/widget/FrameLayout$LayoutParams;

    iput v0, v3, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    iput p2, v3, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {v2, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_4
    return v1

    :cond_5
    if-ne v0, v1, :cond_9

    iget-boolean p2, p0, Lcom/hz/en/AutoQuest$1;->moved:Z

    if-nez p2, :cond_9

    iget-object p2, p0, Lcom/hz/en/AutoQuest$1;->val$btn:Landroid/widget/TextView;

    invoke-static {p2}, Lcom/hz/en/AutoQuest;->toggleFarm(Landroid/widget/TextView;)V

    :cond_9
    return v1
.end method
