.class Lcom/hz/en/AutoQuest$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final synthetic val$activity:Lcom/lori/app/PipActivity;

.method constructor <init>(Lcom/lori/app/PipActivity;)V
    .locals 0

    iput-object p1, p0, Lcom/hz/en/AutoQuest$2;->val$activity:Lcom/lori/app/PipActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public run()V
    .locals 1

    iget-object v0, p0, Lcom/hz/en/AutoQuest$2;->val$activity:Lcom/lori/app/PipActivity;

    invoke-static {v0}, Lcom/hz/en/AutoQuest;->attachOverlayOnUi(Lcom/lori/app/PipActivity;)V

    return-void
.end method
