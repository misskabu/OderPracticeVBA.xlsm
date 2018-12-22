VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Customer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'���󉼂ɈႤ�N���X�Ń����_���l���g���Ă��邪�������AI������B
'���q�l��\���N���X������������B�̔����̌�����s���B
'���q�l�͗j���A�V��ɂ���Đl���������B
'���̓��I�ɂ��鏤�i�ȏ�͔����Ȃ��B
'�w���ӗ~���K��|�C���g�ȏゾ�Ɣ����B
'��������Ƃɍw���ӗ~�͉�����B
'�l�������Ă���ƍw���ӗ~���オ��B

Private m_pay As Integer '�x���z
Private m_motivation As Integer '�w���ӗ~

Private Sub Class_Initialize()
    m_motivation = 30
    
    Const max As Integer = 25
    Const min As Integer = -15
   
    Randomize
    m_motivation = m_motivation + Int((max - min + 1) * Rnd + min)
    
End Sub
'@return �w����
Public Function BuyItems() As Integer
    
    Dim buyItems_ As Integer
    
    Dim i As Integer
    Dim item_ As Item
    Dim cabinet_ As Cabinet: Set cabinet_ = Main.GetCabinet
    
   
    For i = cabinet_.GetItems.Count - 1 To 1 Step -1
        Set item_ = cabinet_.GetItems.Item(i)
        
        If IsBuy(item_) Then
            buyItems_ = buyItems_ + 1
            m_pay = m_pay + item_.GetPrice
            Const max As Integer = -5
            Const min As Integer = -50
   
            Randomize
            m_motivation = m_motivation + Int((max - min + 1) * Rnd + min)
            m_motivation = m_motivation - 10
            
            cabinet_.GetItems.Remove (i)
        End If
  
    Next i
    BuyItems = buyItems_
    
End Function

'���`�x�[�V���������ʂ𒴂���Ɣ���
'@return �������ǂ���
Private Function IsBuy(item_ As Item) As Boolean

    If item_.GetPrice < 100 Then
        m_motivation = m_motivation + 10
    End If
    
    If m_motivation > 50 Then
        IsBuy = True
    End If
    
End Function

Public Function GetPay() As Integer
    GetPay = m_pay
End Function
